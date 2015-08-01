//
//  BuddyListController.swift
//  WeiXin
//
//  Created by chen.wenqiang on 15/7/29.
//
//

import UIKit

class BuddyListController: UITableViewController, StatusDelegate, MessageDelegate {
    @IBOutlet weak var myStatus: UIBarButtonItem!
    @IBAction func logChange(sender: UIBarButtonItem) {
        // 根据当前在线状态，调整状态图片和进行上下线的操作
        if logged {
            logoff()
            // 图片改成离线
            sender.image = UIImage(named: "off")
        } else {
            login()
            sender.image = UIImage(named: "on")
        }
    }
    
    // 未读消息数组
    var unreadList = [Message]()
    
    // 好友状态数组，作为表格的数据源
    var statusList = [Status]()
    
    // 已登入
    var logged = false
    
    // 选择聊天的好友
    var currentBuddyName = ""
    
    // 自己离线
    func selfOff() {
        logoff()
    }
    
    // 收到离线或未读消息
    func newMsg(msg: Message) {
        // 如果消息有正文，则加入到未读消息组，通知表格刷新
        if (msg.body != "") {
            // 则加入到未读消息组
            unreadList.append(msg)
            
            // 通知表格刷新
            self.tableView.reloadData()
        }
    }
    
    // 上线状态处理
    func isOn(status: Status) {
        // 逐条查找
        for (index, oldStatus) in enumerate(statusList) {
            // 如果找到旧的用户的状态
            if (status.name == oldStatus.name) {
                // 移除掉旧的用户状态
                statusList.removeAtIndex(index)
                
                // 一旦找到，跳出循环
                break
            }
        }
        // 添加新状态到状态数组
        statusList.append(status)
        
        // 通知表格刷新
        self.tableView.reloadData()
    }
    
    // 离线状态处理
    func isOff(status: Status) {
        // 逐条查找
        for (index, oldStatus) in enumerate(statusList) {
            // 如果找到旧的用户的状态
            if (status.name == oldStatus.name) {
                // 更改旧的用户状态为离线
                statusList[index].isOnline = false
                
                // 一旦找到，跳出循环
                break
            }
        }
        
        // 通知表格刷新
        self.tableView.reloadData()
    }
    
    // 下线状态处理
    func appDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    // 登入
    func login() {
        // 清空数组
        unreadList.removeAll(keepCapacity: false)
        statusList.removeAll(keepCapacity: false)
        
        appDelegate().connect()
        // 导航栏左侧按钮上线图标
        myStatus.image = UIImage(named: "on")
        logged = true
        
        // 取用户名
        let myID = NSUserDefaults.standardUserDefaults().stringForKey("weixinID")
        // 导航栏标题改成
        self.navigationItem.title = myID! + "的好友"
        
        // 通知表格更新数据
        self.tableView.reloadData()
    }
    
    // 登出
    func logoff() {
        // 清空数组
        unreadList.removeAll(keepCapacity: false)
        statusList.removeAll(keepCapacity: false)
        
        appDelegate().disConnect()
        // 导航栏左侧按钮下线图标
        myStatus.image = UIImage(named: "off")
        logged = false
        
        // 通知表格更新数据
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 取用户名
        let myID = NSUserDefaults.standardUserDefaults().stringForKey("weixinID")
        
        // 取自动登录
        let autoLogin = NSUserDefaults.standardUserDefaults().boolForKey("weixinAutoLogin")
        
        // 如果配置了用户名和自动登录，开始登录
        if (myID != nil && autoLogin) {
            self.login()
            
        } else {
            // 跳转登录视图
            self.performSegueWithIdentifier("toLoginSegue", sender: self)
        }
        
        // 接管消息代理
        appDelegate().messageDelegate = self
        // 接管状态代理
        appDelegate().statusDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("buddyListCell", forIndexPath: indexPath) as! UITableViewCell

        // 好友状态
        let isOnline = statusList[indexPath.row].isOnline
        
        // 好友名字
        let name = statusList[indexPath.row].name
        
        // 未读消息条数
        var unreadNum = 0
        
        // 查找相应好友的未读条数
        for msg in unreadList {
            if (name == msg.from) {
                unreadNum++
            }
        }
        
        // 单元格文本
        cell.textLabel?.text = name + "(\(unreadNum))"
        
        if isOnline {
            cell.imageView?.image = UIImage(named: "on")
        } else {
            cell.imageView?.image = UIImage(named: "off")
        }
        
        return cell
    }

    // 选择单元格
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 保存好友用户名
        currentBuddyName = statusList[indexPath.row].name
        
        // 跳转聊天界面
        self.performSegueWithIdentifier("toChatSegue", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func unwindToBList(segue: UIStoryboardSegue) {
        // 如果是登录界面的完成按钮点击了，开始登录
        let source = segue.sourceViewController as! LoginController
        if source.requireLogin {
            // 注销前一个用户
            self.logoff()
            
            // 登录现用户
            self.login()
            
        }
    }
}
