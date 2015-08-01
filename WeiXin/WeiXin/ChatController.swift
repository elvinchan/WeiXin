//
//  ChatController.swift
//  WeiXin
//
//  Created by chen.wenqiang on 15/7/30.
//
//

import UIKit

class ChatController: UITableViewController, MessageDelegate {
    @IBOutlet weak var msgTextField: UITextField!
    @IBOutlet weak var sendButton: UIBarButtonItem!

    @IBAction func composing(sender: UITextField) {
        // 构建XML元素message
        var xmlMessage = DDXMLElement.elementWithName("message") as! DDXMLElement
        
        // 增加属性
        xmlMessage.addAttributeWithName("to", stringValue:toBuddyName)
        xmlMessage.addAttributeWithName("from", stringValue: NSUserDefaults.standardUserDefaults().stringForKey("weixinID"))
        
        // 构建正在输入元素
        var composing = DDXMLElement.elementWithName("composing") as! DDXMLElement
        composing.addAttributeWithName("xmlns", stringValue: "http://jabber.org/protocol/chatstates")
        
        xmlMessage.addChild(composing)
        
        appDelegate().xs!.sendElement(xmlMessage)
    }
    
    @IBAction func send(sender: UIBarButtonItem) {
        // 获取聊天文本
        let msgStr = msgTextField.text
        
        // 如果不为空
        if (!msgStr.isEmpty) {
            // 构建XML元素message
            var xmlMessage = DDXMLElement.elementWithName("message") as! DDXMLElement
            
            // 增加属性
            xmlMessage.addAttributeWithName("type", stringValue: "chat")
            xmlMessage.addAttributeWithName("to", stringValue:toBuddyName)
            xmlMessage.addAttributeWithName("from", stringValue: NSUserDefaults.standardUserDefaults().stringForKey("weixinID"))
            
            // 构建正文
            var body = DDXMLElement.elementWithName("body") as! DDXMLElement
            body.setStringValue(msgStr)
            
            // 把正文加入到消息的子节点
            xmlMessage.addChild(body)
            
            // 通过通道发送XML文本
            appDelegate().xs!.sendElement(xmlMessage)
            
            // 清空聊天框
            msgTextField.text = ""
            
            // 保存自己发送的消息
            var msg = Message()
            
            msg.isSelf = true
            msg.body = msgStr
            
            // 加入到聊天记录
            msgList.append(msg)
            
            self.tableView.reloadData()
        }
    }
    // 选择聊天的好友
    var toBuddyName = ""
    
    // 聊天记录
    var msgList = [Message]()
    
    // 收到消息
    func newMsg(msg: Message) {
        // 对方正在输入
        if (msg.isComposing) {
            self.navigationItem.title = "对方正在输入..."
        } else if (msg.body != "") {
            self.navigationItem.title = toBuddyName
            
            // 如果消息有正文，则加入到未读消息组，通知表格刷新
            msgList.append(msg)
            
            // 通知表格刷新
            self.tableView.reloadData()
        }
    }
    
    func appDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 接管消息代理
        appDelegate().messageDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("chatCell", forIndexPath: indexPath) as! UITableViewCell
        
        // 取对应的消息
        let msg = msgList[indexPath.row]
        
        // 对单元格的文本的格式做个调整
        if (msg.isSelf) {
            cell.textLabel?.textAlignment = .Right
            cell.textLabel?.textColor = UIColor.grayColor()
        } else {
            cell.textLabel?.textColor = UIColor.orangeColor()
        }
        
        cell.textLabel?.text = msg.body

        return cell
    }
}
