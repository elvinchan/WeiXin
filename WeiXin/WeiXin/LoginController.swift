//
//  LoginController.swift
//  WeiXin
//
//  Created by chen.wenqiang on 15/7/29.
//
//

import UIKit

class LoginController: UIViewController {
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var serverTextField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var autoLoginSwitch: UISwitch!
    
    // 需要登录
    var requireLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender as! UIBarButtonItem == self.doneButton {
            NSUserDefaults.standardUserDefaults().setObject(userTextField.text, forKey: "weixinID")
            NSUserDefaults.standardUserDefaults().setObject(pwdTextField.text, forKey: "weixinPwd")
            NSUserDefaults.standardUserDefaults().setObject(serverTextField.text, forKey: "weixinServer")
            NSUserDefaults.standardUserDefaults().setObject(autoLoginSwitch.on, forKey: "weixinAutoLogin")
            
            // 同步配置
            NSUserDefaults.standardUserDefaults().synchronize()
            
            // 需要登录
            requireLogin = true
        }
    }
    

}
