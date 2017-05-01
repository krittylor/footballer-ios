//
//  OrderResultController.swift
//  Football
//
//  Created by Admin User on 3/15/17.
//  Copyright © 2017 prosunshining. All rights reserved.
//

import UIKit

class OrderResultController: UIViewController{
    
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var customerLabel: UILabel!
    
    @IBOutlet weak var doneButton: UIButton!

    @IBAction func onBackPressed(_ sender: Any) {
        navigationController?.popViewController(animated : true)
    }
    public var scheduleType: String = ""
    public var customerName: String = ""
    public var orderId: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //replace footballer logo with navigation bar title
        let image = UIImage(named: "footballer_medium")
        self.navigationItem.titleView = UIImageView(image: image)
        
        self.doneButton.layer.cornerRadius = 7
        if(scheduleType != "na"){
            customerLabel.text = "Customer Name: " + customerName
            orderIdLabel.text = "Order Id: " + orderId
        }
        else{
            customerLabel.text = "Not available at the moment"
            orderIdLabel.text = ""
        }
    }
    @IBAction func donePressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
