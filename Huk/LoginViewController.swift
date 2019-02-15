//
//  LoginViewController.swift
//  Huk
//
//  Created by comsoft on 2019. 1. 21..
//  Copyright © 2019년 comsoft. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var EmailText: UITextField!
    @IBOutlet weak var PwText: UITextField!
    @IBOutlet weak var LoginB: UIButton!
    @IBOutlet weak var SignUp: UIButton!
    let remoteconfig = RemoteConfig.remoteConfig()
    var color : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        try! Auth.auth().signOut()
        let statusBar = UIView()
        self.view.addSubview(statusBar)
        statusBar.snp.makeConstraints{ (m) in
            m.right.top.left.equalTo(self.view)
            m.height.equalTo(20)
        }
        
        color = remoteconfig["splash_background"].stringValue
        statusBar.backgroundColor = UIColor(hex: color)
        LoginB.backgroundColor = UIColor(hex: color)
        SignUp.backgroundColor = UIColor(hex: color)
        SignUp.addTarget(self, action:  #selector(signPresent), for: .touchUpInside )
        LoginB.addTarget(self, action: #selector(loginEvent), for: .touchUpInside)
        
        Auth.auth().addStateDidChangeListener {(auth, user) in
            if(user != nil){
                let view = self.storyboard?.instantiateViewController(withIdentifier: "MainViewTabBarController") as! UITabBarController
                self.present(view,  animated: true, completion: nil)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func loginEvent(){
        Auth.auth().signIn(withEmail: EmailText.text!, password: PwText.text!){(user, arr) in
            if (arr != nil){
                let alert = UIAlertController(title: "에러", message: arr.debugDescription, preferredStyle: UIAlertControllerStyle.alert )
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                 self.present(alert, animated: true, completion: nil)
            }
           
        }
    }
    @objc func signPresent(){
        let view = self.storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        self.present(view, animated: true, completion: nil )
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
