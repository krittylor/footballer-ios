//
//  ProfileEditController.swift
//  Football
//
//  Created by Admin User on 3/14/17.
//  Copyright © 2017 prosunshining. All rights reserved.
//

import UIKit
import Firebase

class ProfileEditController: UIViewController, UITextFieldDelegate {
    
   
    @IBOutlet weak var phoneNumberEdit: ACFloatingTextfield!
    @IBOutlet weak var birthdayEdit: ACFloatingTextfield!
    @IBOutlet weak var confirmPasswordEdit: ACFloatingTextfield!
    @IBOutlet weak var newPasswordEdit: ACFloatingTextfield!
    @IBOutlet weak var nameEdit: ACFloatingTextfield!
    @IBOutlet weak var phoneContainer: UIView!
    @IBOutlet weak var birthdayContainer: UIView!
    @IBOutlet weak var passwordContainer: UIView!
    @IBOutlet weak var nameContainer: UIView!
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //draw border for each container
        nameContainer.layer.borderWidth = 1
        nameContainer.layer.borderColor = UIColor.lightGray.cgColor
        
        phoneContainer.layer.borderWidth = 1
        phoneContainer.layer.borderColor = UIColor.lightGray.cgColor
        
        birthdayContainer.layer.borderWidth = 1
        birthdayContainer.layer.borderColor = UIColor.lightGray.cgColor
        
        passwordContainer.layer.borderWidth = 1
        passwordContainer.layer.borderColor = UIColor.lightGray.cgColor
        
        nameEdit.delegate = self
        nameEdit.returnKeyType = .done
        newPasswordEdit.delegate = self
        newPasswordEdit.returnKeyType = .done
        confirmPasswordEdit.delegate = self
        confirmPasswordEdit.returnKeyType = .done
        birthdayEdit.delegate = self
        birthdayEdit.returnKeyType = .done
        phoneNumberEdit.delegate = self
        phoneNumberEdit.returnKeyType = .done
    }
    @IBAction func saveButtonPressed(_ sender: Any) {
        let ref = FIRDatabase.database().reference()
        let user = FIRAuth.auth()?.currentUser
        var isPasswordUpdate = true;
        if(newPasswordEdit.text == "" && confirmPasswordEdit.text == ""){
            isPasswordUpdate = false;
        }
        if(newPasswordEdit.text != confirmPasswordEdit.text){
            self.showToast(string: "Password incorrect")
            return
        }
        if(nameEdit.text == ""){
            self.showToast(string: "You haven't input username")
            return
        }
        if(birthdayEdit.text == ""){
            self.showToast(string: "You haven't input birthday")
            return
        }
        if(phoneNumberEdit.text == ""){
            self.showToast(string: "You haven't input phoneNumber")
            return
        }
        if(isPasswordUpdate) {
            user?.updatePassword(newPasswordEdit.text!, completion: nil)
        }
        ref.child("users").child((user?.uid)!).child("userName").setValue(nameEdit.text)
        ref.child("users").child((user?.uid)!).child("birthday").setValue(birthdayEdit.text)
        ref.child("users").child((user?.uid)!).child("phoneNumber").setValue(phoneNumberEdit.text)
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.user?.setValue(nameEdit.text as Any, forKey: "userName")
        delegate.user?.setValue(birthdayEdit.text as Any, forKey: "birthday")
        delegate.user?.setValue(phoneNumberEdit.text as Any, forKey: "phoneNumber")

        ref.child("users").child((user?.uid)!).observeSingleEvent(of: .value, with: {(snapshot) in
            // Check if user already exists
            guard !snapshot.exists() else {
                //self.performSegue(withIdentifier: "signIn", sender: nil)
                let value = snapshot.value as? NSDictionary
                let userTypeFromDB = value?["userType"] as? Int ?? USER_PLAYER
                
                let delegate = UIApplication.shared.delegate as! AppDelegate
                delegate.user = value!
                self.navigationController?.popViewController(animated: true)
                if let profileController = UIApplication.topViewController(){
                    (profileController as? ProfileController)?.birthdayEdit.text = self.birthdayEdit.text
                    (profileController as? ProfileController)?.mobileEdit.text = self.phoneNumberEdit.text
                    (profileController as? ProfileController)?.userNameEdit.text = self.nameEdit.text
                    
                }
                return
            }
        })
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
