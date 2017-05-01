 //
//  FieldDetailController.swift
//  Football
//
//  Created by Admin User on 3/6/17.
//  Copyright © 2017 prosunshining. All rights reserved.
//


import UIKit
import HFSwipeView
import TinyLog
import CLabsImageSlider
import DropDown
class FieldDetailController: UIViewController, imageSliderDelegate {
    

    @IBOutlet weak var fieldImagesSlider: CLabsImageSlider!

    @IBOutlet weak var priceContainer: UIView!
    @IBOutlet weak var mapContainer: UIView!

    @IBOutlet weak var viewMapButton: UIButton!

      @IBOutlet weak var backButton: UIBarButtonItem!

    @IBOutlet weak var scheduleButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    //location info
    @IBOutlet weak var availibilityButton: UIButton!

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var fieldName: UILabel!
    public var latitude: Double?
    public var longitude: Double?
    
    public var urlImages: NSArray!
    public var values: NSDictionary!
    
    //keep fieldId here
    public var fieldId : String?
    @IBAction func viewMap(_ sender: Any) {
        performSegue(withIdentifier: "showMap", sender: self)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fieldImagesSlider.sliderDelegate   =   self
        //round cornor button
        self.viewMapButton.layer.cornerRadius = 7
        self.editButton.layer.cornerRadius = 7
        self.scheduleButton.layer.cornerRadius = 7
        self.availibilityButton.layer.cornerRadius = 7
        self.fieldName.text = values?["locationName"] as? String
        
        //replace title of the title bar
        self.title = values?["fieldName"] as? String
        //init location
        latitude = values?["latitude"] as! Double?
        longitude = values?["longitude"] as! Double?
        
        //show price to the price label
        let price = values?["price"] as! Int
        priceLabel.text = "Price: \(price) SAR"
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //draw custom borders for each components
        priceContainer.drawCustomBorder(type: CUSTOM_BORDER_PRICE)
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    override func viewDidLayoutSubviews() {
        urlImages = (values as? [String: Any])!["photoUrls"] as? NSArray
        if(urlImages != nil){
        
            fieldImagesSlider.setUpView(imageSource: .Url(imageArray:urlImages as! [String],placeHolderImage:UIImage(named:"empty")),slideType:.ManualSwipe,isArrowBtnEnabled: true)
        }
        
        //show white arrows of image slider
        self.fieldImagesSlider.showWhiteArrows()
    }
    
    func didMovedToIndex(index:Int)
    {
        print("did moved at Index : ",index)
    }
    @IBAction func editButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "editField", sender: self)
    }
    @IBAction func scheduleButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "scheduleField", sender: self)
    }
    @IBAction func availibilityButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "editAvailibility", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "showMap"){
            let mapController = segue.destination as! MapController
            mapController.longitude = self.longitude!
            mapController.latitude = self.latitude!
        }
        if(segue.identifier == "editField"){
            let fieldEditController = segue.destination as! FieldEditController
            fieldEditController.mode = EDIT_MODE
            
            fieldEditController.values = values!
            fieldEditController.fieldId = self.fieldId!
            
        }
        if(segue.identifier == "scheduleField"){
            let scheduleController = segue.destination as! ScheduleController
            scheduleController.fieldId = self.fieldId!
            scheduleController.fieldName = (self.values["fieldName"] as? String)!
        }
        if(segue.identifier == "editAvailibility"){
            let availibilityController = segue.destination as! AvailibilityController
            availibilityController.fieldId = self.fieldId!
            availibilityController.fieldName = (self.values["fieldName"] as? String)!
        }
    }
}
