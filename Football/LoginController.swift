//
//  LoginController.swift
//  Football
//
//  Created by Admin User on 3/4/17.
//  Copyright © 2017 prosunshining. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import ALLoadingView
class LoginController: UIViewController, UITextFieldDelegate {
  
    @IBOutlet weak var toSignUpLabel: UILabel!
    @IBOutlet weak var editPassword: ACFloatingTextfield!
    @IBOutlet weak var editEmail: ACFloatingTextfield!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    public var userType:Int = 0x01
    var ref: FIRDatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.loginButton.layer.cornerRadius = 7
        self.backButton.layer.cornerRadius = 7
        self.loginButton.addTarget(self, action: #selector(LoginController.login(_:)), for: .touchUpInside)
        self.ref = FIRDatabase.database().reference()
        self.editEmail.delegate = self
        self.editEmail.returnKeyType = .done
        self.editPassword.delegate = self
        self.editPassword.returnKeyType = .done
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelTapped(tapGestureRecognizer:)))
        toSignUpLabel.isUserInteractionEnabled = true
        toSignUpLabel.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func login(_ sender : AnyObject?) {
        if(sender === loginButton){
            let email = editEmail.text
            let password = editPassword.text
            
            if(email == ""){
                editEmail.errorLineColor = UIColor.red
                editEmail.errorTextColor = UIColor.red
                editEmail.showErrorWithText(errorText: "Input email")
            } else if(password == ""){
                editPassword.errorLineColor = UIColor.red
                editPassword.errorTextColor = UIColor.red
                editPassword.showErrorWithText(errorText: "Input password")
            } else{
                ALLoadingView.manager.showLoadingView(ofType: .basic, windowMode: .fullscreen)
                FIRAuth.auth()?.signIn(withEmail: email!, password: password!, completion: { (user, error) in
                    ALLoadingView.manager.hideLoadingView()
                    guard let user = user, error == nil else {
                        if(((error?._userInfo as! NSDictionary)["error_name"] as! String) == "ERROR_WRONG_PASSWORD"){
                            self.editPassword.errorLineColor = UIColor.red
                            self.editPassword.errorTextColor = UIColor.red
                            self.editPassword.showErrorWithText(errorText: "Wrong password")
                        }
                        if(((error?._userInfo as! NSDictionary)["error_name"] as! String) == "ERROR_INVALID_EMAIL"){
                            self.editEmail.errorLineColor = UIColor.red
                            self.editEmail.errorTextColor = UIColor.red
                            self.editEmail.showErrorWithText(errorText: "Invalid email")
                        }
                        if(((error?._userInfo as! NSDictionary)["error_name"] as! String) == "ERROR_USER_NOT_FOUND"){
                            self.editEmail.errorLineColor = UIColor.red
                            self.editEmail.errorTextColor = UIColor.red
                            self.editEmail.showErrorWithText(errorText: "User not found")
                        }
                        return
                    }
                    
                    self.ref.child("users").child(user.uid).observeSingleEvent(of: .value, with: {(snapshot) in
                        // Check if user already exists
                        guard !snapshot.exists() else {
                            //self.performSegue(withIdentifier: "signIn", sender: nil)
                            let value = snapshot.value as? NSDictionary
                            let userTypeFromDB = value?["userType"] as? Int ?? USER_PLAYER
                            
                            let delegate = UIApplication.shared.delegate as! AppDelegate
                            delegate.user = value!
                            delegate.email = user.email!
                            delegate.userId = user.uid
                            delegate.userType = userTypeFromDB
                            self.performSegue(withIdentifier: "toFieldListView", sender: self)
                            return
                        }
                    })
                })
            }
        }
    }
    
    func labelTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedLabel = tapGestureRecognizer.view as! UILabel
        
        if(tappedLabel == toSignUpLabel){
            performSegue(withIdentifier: "fromLoginToRegister", sender: self)
        }
        // Your action
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}
