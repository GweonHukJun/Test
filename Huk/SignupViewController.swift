//
//  SignupViewController.swift
//  Huk
//
//  Created by comsoft on 2019. 1. 21..
//  Copyright © 2019년 comsoft. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var noSign: UIButton!
    @IBOutlet weak var okSign: UIButton!
    let remoteconfig = RemoteConfig.remoteConfig()
    var color : String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let statusBar = UIView()
        self.view.addSubview(statusBar)
        statusBar.snp.makeConstraints{ (m) in
            m.right.top.left.equalTo(self.view)
            m.height.equalTo(20)
        }
        
        color = remoteconfig["splash_background"].stringValue
        statusBar.backgroundColor = UIColor(hex: color!)
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imagePicker) ))
        
        okSign.backgroundColor = UIColor(hex: color!)
         noSign.backgroundColor = UIColor(hex: color!)
         okSign.addTarget(self, action: #selector(signupEvent), for: .touchUpInside)
        noSign.addTarget(self, action: #selector(cancelEvent), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    @objc func imagePicker(){
        let imageP = UIImagePickerController()
        imageP.delegate = self
        imageP.allowsEditing = true
        imageP.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(imageP, animated: true, completion: nil) 
    }
    
    @objc func signupEvent(){
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (user, err) in
            let uid = Auth.auth().currentUser!.uid
            
            let image = UIImageJPEGRepresentation(self.imageView.image!, 0.1 )
            let aakkk = Storage.storage().reference().child("userImages").child(uid)
            aakkk.putData(image! , metadata: nil) {(data, err) in
                if let err = err {
                    print(err)
                }
                
                aakkk.downloadURL(completion: {(url, error) in
                    if error != nil{
                        return
                    } else {
                        print(url)
    Database.database().reference().child("users").child(uid).setValue(["name":  self.name.text!])
    Database.database().reference().child("users").child(uid).setValue(["profileImage": url])
                    }
                })
            }
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        dismiss(animated: true, completion: nil)
        
    }
    @objc func cancelEvent(){
        self.dismiss(animated: true, completion: nil)
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
