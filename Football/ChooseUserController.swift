//
//  ChooseUserController.swift
//  Football
//
//  Created by Admin User on 3/3/17.
//  Copyright © 2017 prosunshining. All rights reserved.
//

import UIKit

class ChooseUserController: UIViewController {
   
    @IBOutlet weak var playerButton: UIButton!
    @IBOutlet weak var fieldOwnerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.playerButton.layer.cornerRadius = 7
        self.fieldOwnerButton.layer.cornerRadius = 7
        playerButton.addTarget(self, action: #selector(ChooseUserController.buttonClicked(_:)), for: .touchUpInside)
        fieldOwnerButton.addTarget(self, action: #selector(ChooseUserController.buttonClicked(_:)), for: .touchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "registerUser") {
            let secondViewController = segue.destination as! RegisterController;
            let userType = sender as! Int
            secondViewController.userType = userType
        }
    }
    func buttonClicked(_ sender : AnyObject?) {
        if(sender === playerButton){
                performSegue(withIdentifier: "registerUser", sender: USER_PLAYER)
        }
        if(sender === fieldOwnerButton){
                performSegue(withIdentifier: "registerUser", sender: USER_OWNER)
        }
    }
    
}
