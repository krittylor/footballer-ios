//
//  JoinCommunityController.swift
//  Football
//
//  Created by Admin User on 3/2/17.
//  Copyright © 2017 prosunshining. All rights reserved.
//

import UIKit

class JoinCommunityController: UIViewController {
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.loginBtn.layer.cornerRadius = 7
        self.registerBtn.layer.cornerRadius = 7
        self.loginBtn.addTarget(self, action: #selector(JoinCommunityController.buttonClicked(_:)), for: .touchUpInside)
        self.registerBtn.addTarget(self, action: #selector(JoinCommunityController.buttonClicked(_:)), for: .touchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "login") {
            let secondViewController = segue.destination as! LoginController;
            let userType = sender as! Int
            secondViewController.userType = userType
        }
    }
    func buttonClicked(_ sender : AnyObject?) {
        if(sender === loginBtn){
            performSegue(withIdentifier: "login", sender: USER_OWNER)
        }
        if(sender === registerBtn){
            performSegue(withIdentifier: "chooseuser", sender: self)
        }
    }

}
