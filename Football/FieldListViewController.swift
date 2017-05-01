 //
//  FieldsListController.swift
//  Football
//
//  Created by Admin User on 3/5/17.
//  Copyright © 2017 prosunshining. All rights reserved.
//


import UIKit
import Firebase
import FirebaseDatabaseUI
import SDWebImage

class FieldListViewController: UITableViewController{
    
    //key to filter the location
    public var locationFilter: String = ""
    public var userId: String = ""
    public var userType: Int = USER_OWNER
    // [START define_database_reference]
    var ref: FIRDatabaseReference!
    // [END define_database_reference]
    
    var dataSource: FirebaseTableViewDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //replace footballer logo with navigation bar title
        let image = UIImage(named: "footballer_medium")
        self.navigationItem.titleView = UIImageView(image: image)
        
        //remove separator line between tableview cells
        self.tableView.separatorStyle = .none
        //init userId  and userType from AppDelegate
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if(delegate?.userId != nil){
            userId = (delegate?.userId)!
        }
        self.userType = (delegate?.userType)!
        
        if(self.userType == USER_PLAYER){
            let imageForRightItem = UIImage(named: "filter")
            self.navigationItem.rightBarButtonItem?.image = imageForRightItem
        }
        
        
        // [START create_database_reference]
        ref = FIRDatabase.database().reference()
        // [END create_database_reference]
        print("Table initialization")
        dataSource = FirebaseTableViewDataSource.init(query: getQuery(),
                                              modelClass: Field.self,
                                              nibNamed: "FieldListViewCell",
                                              cellReuseIdentifier: "field",
                                              view: tableView)

        dataSource?.populateCell() {
            guard let cell = $0 as? FieldListViewCell else {
                return
            }
            guard let field = $1 as? Field else {
                return
            }
            if(field.photoUrls.count > 0){
                if let url = URL(string: (field.photoUrls[0] as? String)!) {
                    cell.fieldPhoto.sd_setShowActivityIndicatorView(true)
                    cell.fieldPhoto.sd_setIndicatorStyle(.gray)
                    cell.fieldPhoto.sd_setImage(with: url)
                    
                }
            } else {
                cell.fieldPhoto.image = nil
            }
            cell.editFieldName.text = field.fieldName
            cell.editLocationName.text = field.locationName
            cell.editPrice.text = String(field.price)
        }
        
        tableView.dataSource = dataSource
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(self.userType == USER_OWNER){
            performSegue(withIdentifier: "fieldDetail", sender: indexPath)
        } else {
            performSegue(withIdentifier: "fieldDetailForPlayer", sender: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let navigationBarHeight: CGFloat = self.navigationController!.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        return (tableView.frame.size.height - navigationBarHeight - statusBarHeight) / 2
    }
    
    func getUid() -> String {
        return (FIRAuth.auth()?.currentUser?.uid)!
    }
    
    func getQuery() -> FIRDatabaseQuery {
        if(locationFilter != "") {
            print("LocationFilter:" + locationFilter)
            return (ref?.child("fields"))!.queryOrdered(byChild: "locationName").queryEqual(toValue: locationFilter)
        }
        if(userId != "" && self.userType == USER_OWNER){
            return (ref?.child("fields").queryOrdered(byChild: "fieldOwner").queryEqual(toValue: String(userId)))!
        }
        return (ref?.child("fields"))!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "fieldDetail"){
           guard let path: IndexPath = sender as? IndexPath else { return }
           guard let detail: FieldDetailController = segue.destination as? FieldDetailController else {
               return
           }
           let source = self.dataSource
           guard let snapshot: FIRDataSnapshot = (source?.object(at: UInt((path as NSIndexPath).row)))! as? FIRDataSnapshot else {
               return
           }
            let values:Any = snapshot.value as! [String:Any]
            detail.values = values as! NSDictionary
            detail.fieldId = snapshot.key
        }
        
        if(segue.identifier == "fieldDetailForPlayer"){
            guard let path: IndexPath = sender as? IndexPath else { return }
            guard let detail: FieldDetailPlayerController = segue.destination as? FieldDetailPlayerController else {
                return
            }
            let source = self.dataSource
            guard let snapshot: FIRDataSnapshot = (source?.object(at: UInt((path as NSIndexPath).row)))! as? FIRDataSnapshot else {
                return
            }
            let values:Any = snapshot.value as! [String:Any]
            detail.values = values as! NSDictionary
            detail.fieldId = snapshot.key
        }
        
        if(segue.identifier == "fieldEditDetail"){
            guard let fieldEditController = segue.destination as? FieldEditController else{
                return
            }
            fieldEditController.userId = self.userId
        }
     }
    
    override func viewWillDisappear(_ animated: Bool) {
        getQuery().removeAllObservers()
    }
    @IBAction func fieldAddPressed(_ sender: Any) {
        
        if(self.userType == USER_OWNER){
            performSegue(withIdentifier: "fieldEditDetail", sender: self)
        } else {
            performSegue(withIdentifier: "filterLocations", sender: self)
        }
    }
    
    func reloadTable(){
        //DispatchQueue.main.async{
        
        dataSource = FirebaseTableViewDataSource.init(query: getQuery(),
                                                      modelClass: Field.self,
                                                      nibNamed: "FieldListViewCell",
                                                      cellReuseIdentifier: "field",
                                                      view: tableView)
        dataSource?.populateCell() {
            guard let cell = $0 as? FieldListViewCell else {
                return
            }
            guard let field = $1 as? Field else {
                return
            }
            
            if field.photoUrls.count > 0 {
                if let url = URL(string: (field.photoUrls[0] as? String)!){
                    cell.fieldPhoto.sd_setShowActivityIndicatorView(true)
                    cell.fieldPhoto.sd_setIndicatorStyle(.gray)
                    cell.fieldPhoto.sd_setImage(with: url)
                }
            } else {
                cell.fieldPhoto.image = nil
            }
            cell.editFieldName.text = field.fieldName
            cell.editLocationName.text = field.locationName
            cell.editPrice.text = String(field.price)
        }
        tableView.dataSource = dataSource
        tableView.delegate = self
        //self.tableView.reloadData()
        //}
    }
}
