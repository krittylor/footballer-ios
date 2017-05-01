//
//  SideMenuController.swift
//  Football
//
//  Created by Admin User on 3/5/17.
//  Copyright © 2017 prosunshining. All rights reserved.
//

import Foundation
import SideMenu
import UIKit
import FirebaseAuth
class SideMenuTableController: UITableViewController {
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // this will be non-nil if a blur effect is applied
        guard tableView.backgroundView == nil else {
            return
        }
        print("SideMenuTable")
        // Set up a cool background image for demo purposes
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0){
            
            performSegue(withIdentifier: "showProfile", sender: self)
        } else if (indexPath.row == 1){
            performSegue(withIdentifier: "aboutUs", sender: self)
        } else if (indexPath.row == 2){
            try! FIRAuth.auth()!.signOut()
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "joinCommunityBoard") as! UINavigationController
            self.present(vc, animated: false, completion: nil)
        }
    }
}
