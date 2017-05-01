//
//  RegisterController.swift
//  Football
//
//  Created by Admin User on 3/3/17.
//  Copyright © 2017 prosunshining. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
class RegisterController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var toSignInLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!

    
    @IBOutlet weak var editEmail: ACFloatingTextfield!
    
    @IBOutlet weak var editPassword: ACFloatingTextfield!
    @IBOutlet weak var editName: ACFloatingTextfield!
    
    var ref: FIRDatabaseReference!
    
    public var userType:Int = 0x01
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.registerButton.layer.cornerRadius = 7
        self.backButton.layer.cornerRadius = 7
        self.registerButton.addTarget(self, action: #selector(RegisterController.register(_:)), for: .touchUpInside)
        ref = FIRDatabase.database().reference()
        editEmail.delegate = self
        editEmail.returnKeyType = .done
        editEmail.errorTextColor = UIColor.red
        editPassword.delegate = self
        editPassword.returnKeyType = .done
        editName.delegate = self
        editName.returnKeyType = .done
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelTapped(tapGestureRecognizer:)))
        toSignInLabel.isUserInteractionEnabled = true
        toSignInLabel.addGestureRecognizer(tapGestureRecognizer)
    }
    func labelTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedLabel = tapGestureRecognizer.view as! UILabel
        
        if(tappedLabel == toSignInLabel){
            performSegue(withIdentifier: "fromRegisterToLogin", sender: self)
        }
        
        // Your action
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Saves user profile information to user database
    func saveUserInfo(_ user: FIRUser, withUserName userName: String, withUserType userType: Int) {
        
        // Create a change request
        
        let changeRequest = FIRAuth.auth()?.currentUser?.profileChangeRequest()
        changeRequest?.displayName = userName
        
        // Commit profile changes to server
        changeRequest?.commitChanges() { (error) in
            if error != nil {
                self.showToast(string: "An error occured")
                return
            }
            
            // [START basic_write]
            self.ref.child("users").child(user.uid).setValue(["userName": userName, "userType": userType])
            // [END basic_write]
            //self.performSegue(withIdentifier: "signIn", sender: nil)
        }
    }
    
    func register(_ sender : AnyObject?) {
        if(sender === registerButton){
            let userName = editName.text
            let email = editEmail.text
            let password = editPassword.text
            
            if(userName == ""){
                self.editName.errorLineColor = UIColor.red
                self.editName.errorTextColor = UIColor.red
                self.editName.showErrorWithText(errorText: "Input username")
            } else if(email == ""){
                self.editEmail.errorLineColor = UIColor.red
                self.editEmail.errorTextColor = UIColor.red
                self.editEmail.showErrorWithText(errorText: "Input password")
            } else if(password == ""){
                self.editPassword.errorLineColor = UIColor.red
                self.editPassword.errorTextColor = UIColor.red
                self.editPassword.showErrorWithText(errorText: "Input password")
            } else{
                FIRAuth.auth()?.createUser(withEmail: email!, password: password!, completion: { (user, error) in
                    guard let user = user, error == nil else {
                        if(((error?._userInfo as! NSDictionary)["error_name"] as! String) == "ERROR_WRONG_PASSWORD"){
                            self.editPassword.errorLineColor = UIColor.red
                            self.editPassword.errorTextColor = UIColor.red
                            self.editPassword.showErrorWithText(errorText: "Input password")
                        }
                        if(((error?._userInfo as! NSDictionary)["error_name"] as! String) == "ERROR_INVALID_EMAIL"){
                            self.editEmail.errorLineColor = UIColor.red
                            self.editEmail.errorTextColor = UIColor.red
                            self.editEmail.showErrorWithText(errorText: "Input password")
                        }
                        if(((error?._userInfo as! NSDictionary)["error_name"] as! String) == "ERROR_EMAIL_ALREADY_IN_USE"){
                            self.editEmail.errorLineColor = UIColor.red
                            self.editEmail.errorTextColor = UIColor.red
                            self.editEmail.showErrorWithText(errorText: "User already exists")
                        }
                        if(((error?._userInfo as! NSDictionary)["error_name"] as! String) == "ERROR_WRONG_PASSWORD"){
                            self.editPassword.errorLineColor = UIColor.red
                            self.editPassword.errorTextColor = UIColor.red
                            self.editPassword.showErrorWithText(errorText: "Input password")
                        }
                        if(((error?._userInfo as! NSDictionary)["error_name"] as! String) == "ERROR_WEAK_PASSWORD"){
                            self.editPassword.errorLineColor = UIColor.red
                            self.editPassword.errorTextColor = UIColor.red
                            self.editPassword.showErrorWithText(errorText: "Password length must larger than 6")
                        }
                        return
                    }
                    
                    self.saveUserInfo(user, withUserName: userName!, withUserType: self.userType)
                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.userId = user.uid
                    delegate.userType = self.userType
                    delegate.user = ["email": user.email!
                        , "userType" : self.userType
                        , "password" : password!
                        , "userName": userName!
                        , "phoneNumber": ""
                        , "birthday": ""
                    ]
                    self.performSegue(withIdentifier: "registerToFieldListView", sender: self)
                })
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
 }
