//
//  FilterController.swift
//  Football
//
//  Created by Admin User on 3/9/17.
//  Copyright © 2017 prosunshining. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabaseUI
import SDWebImage
class FilterController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var locationTableView: UITableView!
    //location filter variable
    var locationFilter: String?
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    // [START define_database_reference]
    @IBOutlet weak var saveFilterButton: UIButton!
    var ref: FIRDatabaseReference!
    // [END define_database_reference]
    var firstSelection: Bool = true
    var locations = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // [START create_database_reference]
        ref = FIRDatabase.database().reference()
        // [END create_database_reference]
        
        //remove separator line between tableview cells
        self.locationTableView.separatorStyle = .none
        
        print("Table initialization")
        
        
        
        //make save filter button round
        saveFilterButton.layer.cornerRadius = 7
        
        //init locations from db
        ref?.child("fields").observeSingleEvent(of: .value, with: {(snapshot) in
            for child in snapshot.children{
                let field = child as! FIRDataSnapshot
                var addFlag = true;
                var newLocation = (field.value as! NSDictionary)["locationName"] as! String
                var i: Int = 0
                for location in self.locations{
                    if(location == newLocation){
                        addFlag = false;
                    }
                }
                if(addFlag == true){
                    self.locations.append(newLocation)
                }
                self.locationFilter = self.locations[0]
            }
            self.locationTableView.dataSource = self
            self.locationTableView.delegate = self
            
            self.locationTableView.reloadData()
//            let rowToSelect: IndexPath = IndexPath(row: 0, section: 0)
//            self.tableView(self.locationTableView, didSelectRowAt: rowToSelect);
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.locationTableView.reloadData()
    }
    
    
    
    @IBAction func closeFilterPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func saveFilterButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        let fieldListViewController = UIApplication.topViewController() as! FieldListViewController
        fieldListViewController.locationFilter = locationFilter!
        fieldListViewController.reloadTable()
    }
    @IBAction func onClearFilter(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        let fieldListViewController = UIApplication.topViewController() as! FieldListViewController
        fieldListViewController.locationFilter = ""
        fieldListViewController.reloadTable()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            locationFilter = cell.textLabel?.text
        }
//        if firstSelection == false{
//            let rowToSelect: IndexPath = IndexPath(row: 0, section: 0)
//            if let cell = tableView.cellForRow(at: rowToSelect) {
//                cell.accessoryType = .none
//            }
//        }
//        if firstSelection == true {
//            firstSelection = false;
//        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = locationTableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = locations[indexPath.row]
        
        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
