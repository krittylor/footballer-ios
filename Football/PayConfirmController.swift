//
//  PayConfirmController.swift
//  Football
//
//  Created by Admin User on 3/16/17.
//  Copyright © 2017 prosunshining. All rights reserved.
//

import UIKit
import FirebaseDatabase
import CLabsImageSlider

class PayConfirmController: UIViewController, imageSliderDelegate{
    public var fieldId: String?
    public var orderId: Int?
    public var year: Int?
    public var month: Int?
    public var day: Int?
    public var time: Int?
    public var durationType: Int?
    fileprivate var monthStrings = ["January", "Feburary", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    fileprivate var weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    public var weekDay : String?
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageSlider: CLabsImageSlider!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButton.layer.cornerRadius = 7
        if(orderId != nil){
            orderIdLabel.text = String(self.orderId!)
        }
        
        var dayComponent = DateComponents()
        dayComponent.year = self.year
        dayComponent.month = self.month
        dayComponent.day = self.day
        
        let userCalendar = Calendar.current
        
        let tempDay = userCalendar.date(from: dayComponent)!
        let dayOfWeek = userCalendar.component(.weekday, from: tempDay)
        
        weekDay = weekDays[dayOfWeek - 1]
        //set date of the confirm screen
        let dateStr = "\(weekDay!) - \(monthStrings[self.month! - 1]) \(String(self.day!))"
        dateLabel.text = dateStr
        //set time of the confirm screen
        let firstSuffix = self.time! >= 12 ? "PM" : "AM"
        var endTime : Int! = self.durationType == DURATION_60_MINUTES ? self.time! + 1 : self.time! + 2
        if(endTime >= 24) {
            endTime = endTime % 24
        }
        let secondSuffix = endTime >= 12 ? "PM" : "AM"
        let timeStr = "\(self.time!):00 PM - \(endTime!):00 PM"
        timeLabel.text = timeStr
    }
    
    override func viewDidLayoutSubviews() {
        let ref = FIRDatabase.database().reference()
        ref.child("fields").child(fieldId!).observeSingleEvent(of: .value, with: {
            (snapshot) in
            let value = snapshot.value as? NSDictionary
            let photoUrls = value?["photoUrls"] as? [String]
            self.imageSlider.setUpView(imageSource: .Url(imageArray:photoUrls!,placeHolderImage:UIImage(named:"footballer")),slideType:.ManualSwipe,isArrowBtnEnabled: true)
        })
        self.imageSlider.showWhiteArrows()
    }
    
    func didMovedToIndex(index:Int)
    {
        print("did moved at Index : ",index)
    }
}
