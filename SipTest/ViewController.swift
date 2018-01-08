//
//  ViewController.swift
//  SipTest
//
//  Created by Zhe Cui on 12/17/17.
//  Copyright © 2017 Zhe Cui. All rights reserved.
//

import UIKit

enum SIPNotification: String {
    case incomingVideo = "SIPIncomingVideoNotification"
    case callState = "SIPCallStatusChangedNotification"
    case registrationState = "SIPRegisterStatusNotification"

    var notification: Notification.Name {
        return Notification.Name(rawValue: self.rawValue)
    }
}

//var desc = pj_thread_desc()
//var thread = pj_thread_t()

class ViewController: UIViewController {

    @IBOutlet weak var serverURITextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(tapToDismissKeyboard)))
        
        serverURITextField.text = "siptest.butterflymx.com"
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleRegistrationStatus), name: SIPNotification.registrationState.notification, object: nil)
    }
    
//    @objc func tapToDismissKeyboard() {
//        view.endEditing(true)
//    }
    
    @IBAction func tapLoginButton(_ sender: UIButton) {
        var accountID = pjsua_acc_id()
        var accountConfig = pjsua_acc_config()
        
        pjsua_acc_config_default(&accountConfig)
        
        let fullURL = ("sip:\(usernameTextField.text!)@\(serverURITextField.text!)" as NSString).utf8String
        // Always use "sips" for server
        let uri = ("sips:\(serverURITextField.text!)" as NSString).utf8String
        let realm = ("\(serverURITextField.text!)" as NSString).utf8String
        let username = ("\(usernameTextField.text!)" as NSString).utf8String
        var password = ("\(passwordTextField.text!)" as NSString).utf8String

        // Bypass password for test use.
        if usernameTextField.text! == "6728" {
            password = ("123456" as NSString).utf8String!
            passwordTextField.text = String(cString: password!)
        }
        
        if usernameTextField.text! == "panel_4" {
            password = ("123" as NSString).utf8String!
            passwordTextField.text = String(cString: password!)
        }
        
        accountConfig.id = pj_str(UnsafeMutablePointer<Int8>(mutating: fullURL))
        accountConfig.reg_uri = pj_str(UnsafeMutablePointer<Int8>(mutating: uri))
        accountConfig.reg_retry_interval = 0
        accountConfig.cred_count = 1
        accountConfig.cred_info.0.realm = pj_str(UnsafeMutablePointer<Int8>(mutating: realm))
        accountConfig.cred_info.0.username = pj_str(UnsafeMutablePointer<Int8>(mutating: username))
        accountConfig.cred_info.0.data_type = Int32(PJSIP_CRED_DATA_PLAIN_PASSWD.rawValue)
        accountConfig.cred_info.0.data = pj_str(UnsafeMutablePointer<Int8>(mutating: password))

        // Show incoming video
        //accountConfig.vid_in_auto_show = pj_bool_t(PJ_TRUE.rawValue)

        app_config_init_video(&accountConfig)

//        if(!pj_thread_is_registered())
//        {
//            if (pj_thread_register(NULL,desc,&pthread) == PJ_SUCCESS)
//            {
//                //thread_registered = PJ_TRUE;
//            }
//        }
        
//        pj_thread_register(NULL,desc,&pthread)
        
        var status: pj_status_t = pjsua_acc_add(&accountConfig, pj_bool_t(PJ_TRUE.rawValue), &accountID)
        
        if status != PJ_SUCCESS.rawValue {
            print("Register error, status: \(status)")
            return
        }
        
        status = pjsua_acc_set_online_status(pjsua_acc_get_default(), pj_bool_t(PJ_TRUE.rawValue))
        if status != PJ_SUCCESS.rawValue {
            fatalError()
        }
        
        performSegue(withIdentifier: "segueLoginToOutgoingCall", sender: self)
        
//        accountConfig.vid_out_auto_transmit = pj_bool_t(PJ_TRUE.rawValue)
        
//        accountConfig.vid_wnd_flags = PJMEDIA_VID_DEV_WND_BORDER.rawValue | PJMEDIA_VID_DEV_WND_RESIZABLE.rawValue
//        accountConfig.vid_cap_dev = PJMEDIA_VID_DEFAULT_CAPTURE_DEV.rawValue
//        accountConfig.vid_rend_dev = 0
    }
    
    @objc func handleRegistrationStatus(_ notification: Notification) {
        let accountID: pjsua_acc_id = notification.userInfo!["acc_id"] as! pjsua_acc_id
        let status: NSNumber = notification.userInfo!["status"] as! NSNumber
        let statusText: String = notification.userInfo!["status_text"] as! String
        
        if status != 200 {
            print("Registration failed, status: \(status, statusText) ")
            
            return
        }
        
        UserDefaults.standard.set(accountID, forKey: "loginAccountID")
        UserDefaults.standard.set(self.serverURITextField.text, forKey: "serverURI")
        UserDefaults.standard.synchronize()
        
        performSegue(withIdentifier: "segueLoginToOutgoingCall", sender: self)
    }

}

