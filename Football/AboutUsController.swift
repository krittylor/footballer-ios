//
//  Aboutus.swift
//  Football
//
//  Created by Admin User on 3/14/17.
//  Copyright © 2017 prosunshining. All rights reserved.
//

import UIKit

class AboutUsController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.layer.cornerRadius = 7
    }
}
