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
import FirebaseDatabase
class FieldDetailPlayerController: UIViewController, imageSliderDelegate {
    
    
    @IBOutlet weak var fieldImagesSlider: CLabsImageSlider!
    
    @IBOutlet weak var durationDetailContainer: UIView!
    @IBOutlet weak var durationContainer: UIView!
    @IBOutlet weak var priceContainer: UIView!
    @IBOutlet weak var mapContainer: UIView!
    @IBOutlet weak var selectDateButton: UIButton!
    @IBOutlet weak var viewMapButton: UIButton!
    @IBOutlet weak var durationDropDownView: UIView!
    @IBOutlet weak var selectMonth: UIView!
    @IBOutlet weak var selectTime: UIView!
    @IBOutlet weak var selectDay: UIView!
    @IBOutlet weak var selectMap: UIView!
    @IBOutlet weak var selectDuration: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    fileprivate let MONTH_TAG = 0x01
    fileprivate let DAY_TAG = 0x02
    fileprivate let TIME_TAG = 0x03
    fileprivate let SELECTDAY_WEEK = 0x04
    fileprivate let SELECTDAY_DAY = 0x05
    fileprivate let SELECTTIME_TIME = 0x06
    fileprivate let SELECTTIME_BALL = 0x07
    //date info
    public var year: Int?
    public var month: Int?
    public var day: Int?
    public var time: Int?
    
    
    //duration info
    public var durationType: Int?
    public var durDropDown: DropDown?
    
    //location info
    public var latitude: Double?
    public var longitude: Double?
    
    
    //fieldId info
    public var fieldId: String?
    public var urlImages: NSArray!
    public var values: NSDictionary!
    
    //choose month section
    fileprivate let sampleCount: Int = 12
    fileprivate var swipeMonthView: HFSwipeView!
    fileprivate var itemSize: CGSize {
        return CGSize(width: self.view.frame.size.width, height: self.selectMap.frame.size.height)
    }
    fileprivate var itemMonthSize: CGSize {
        return CGSize(width: self.view.frame.size.width, height: self.selectMonth.frame.size.height)
    }
    fileprivate var swipeMonthViewFrame: CGRect {
        return CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 100)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    fileprivate var currentView: UIView?
    
    
    
    @IBAction func durationSelect(_ sender: Any) {
        durDropDown?.show()
    }
    //choose day section
    fileprivate var swipeDayView: HFSwipeView!
    @IBOutlet weak var dropdownButton: UIButton!
    fileprivate var daysCount: Int = 30
    fileprivate var currentDayView: UIView?
    fileprivate var itemDaySize: CGSize {
        return CGSize(width: self.view.frame.size.width / 5.0, height: self.selectDay.frame.size.height)
        
    }
    
    //choose time section
    fileprivate var timesCount: Int = 7
    fileprivate var itemTimeSize: CGSize {
        return CGSize(width: self.view.frame.size.width / 4.0, height: self.selectTime.frame.size.height)
    }
    fileprivate var currentTimeView: UIView?
    fileprivate var swipeTimeView: HFSwipeView!
    
    //constants
    fileprivate var monthStrings = ["January", "Feburary", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    fileprivate var weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    fileprivate var times = ["AM", "PM"]
    fileprivate var durations = ["60 minutes", "120 minutes"]
    
    
    fileprivate var swipeViewFrame: CGRect {
        return CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 100)
    }
    
    @IBOutlet weak var durationLabel: UILabel!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.automaticallyAdjustsScrollViewInsets = true
    }
    
    
    @IBAction func viewMap(_ sender: Any) {
        performSegue(withIdentifier: "showMap", sender: self)
    }
    @IBAction func orderField(_ sender: Any) {
        //check the availibility of ordering
        let dateTime = "\(self.year!)-\(self.month!)-\(self.day! + 1)-\(self.time!)"
        let ref = FIRDatabase.database().reference()
        ref.child("field-schedule").child(self.fieldId!).child(dateTime).observeSingleEvent(of: .value, with: {
            (snapshot) in
            if (snapshot.value as? NSDictionary) != nil{
                self.showToast(string: "Not available to use")
                return
            } else{
                if(self.durationType == DURATION_120_MINUTES){
                    let dateTime1 = "\(self.year!)-\(self.month!)-\(self.day! + 1)-\(self.time! + 1)"
                    ref.child("field-schedule").child(self.fieldId!).child(dateTime1).observeSingleEvent(of: .value, with: {(snapshot) in
                        if (snapshot.value as? NSDictionary) != nil{
                            self.showToast(string: "Not available to use")
                            return
                        } else{
                            self.performSegue(withIdentifier: "orderField", sender: self)
                        }
                    })
                } else{
                    self.performSegue(withIdentifier: "orderField", sender: self)
                }
            }
            
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "showMap"){
            let mapController = segue.destination as! MapPlayerController;
            mapController.longitude = self.longitude!
            mapController.latitude = self.latitude!
        }
        if(segue.identifier == "orderField"){
            let orderFieldController = segue.destination as! OrderFieldController
            let delegate = UIApplication.shared.delegate as! AppDelegate
            orderFieldController.fieldId = self.fieldId
            orderFieldController.userId = delegate.userId
            orderFieldController.year = self.year!
            orderFieldController.month = self.month!
            orderFieldController.day = self.day! + 1
            orderFieldController.time = self.time! + 5
            orderFieldController.durationType = self.durationType
            orderFieldController.price = values["price"] as? Int
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = values?["fieldName"] as? String
        fieldImagesSlider.sliderDelegate   =   self
        //round cornor button
        self.viewMapButton.layer.cornerRadius = 7
        self.selectDateButton.layer.cornerRadius = 7
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        _ = calendar.component(.month, from: date)
        _ = calendar.component(.day, from: date)
        
        self.month = 1
        self.day = 0
        self.year = year
        self.time = 0
        //init choose month section
        currentDayView = nil
        currentTimeView = nil
        
        swipeMonthView = HFSwipeView(frame: swipeViewFrame)
        swipeMonthView.autoAlignEnabled = true
        swipeMonthView.circulating = false
        swipeMonthView.dataSource = self
        swipeMonthView.delegate = self
        swipeMonthView.pageControlHidden = true
        swipeMonthView.tag = MONTH_TAG
        selectMonth.addSubview(swipeMonthView)
        
        swipeDayView = HFSwipeView(frame: swipeViewFrame)
        swipeDayView.autoAlignEnabled = false
        swipeDayView.circulating = false
        swipeDayView.dataSource = self
        swipeDayView.delegate = self
        swipeDayView.pageControlHidden = true
        swipeDayView.tag = DAY_TAG
        selectDay.addSubview(swipeDayView)
        
        //init choose time section
        swipeTimeView = HFSwipeView(frame: swipeViewFrame)
        swipeTimeView.autoAlignEnabled = false
        swipeTimeView.circulating = false
        swipeTimeView.dataSource = self
        swipeTimeView.delegate = self
        swipeTimeView.pageControlHidden = true
        swipeTimeView.tag = TIME_TAG
        selectTime.addSubview(swipeTimeView)
        
        //init duration
        durDropDown = DropDown()
        
        durDropDown?.anchorView = durationDropDownView
        
        durDropDown?.dataSource = durations
        durDropDown?.cancelAction = {[unowned self] in
            print("Drop down dismissed")
            self.durationLabel.text = self.durDropDown?.selectedItem
        }
        
        durDropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
            self.durationLabel.text = item
            self.durationType = index
            
            let price = self.values?["price"] as? Int
            
            self.priceLabel.text = "Price: \(price! * (self.durationType! + 1)) SAR"
            print("Selected item: \(item) at index: \(index)")
        }
        
        durationType = DURATION_60_MINUTES
        
        //set price label text
        let price = self.values?["price"] as? Int
        
        self.priceLabel.text = "Price: \(price! * (self.durationType! + 1)) SAR"
        
        //replace title of the title bar
        self.title = values?["fieldName"] as? String
        //init location
        latitude = values?["latitude"] as! Double?
        longitude = values?["longitude"] as! Double?
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.swipeMonthView!.enableArrows()
        
        //draw custom borders for each components
        priceContainer.drawCustomBorder(type: CUSTOM_BORDER_PRICE)
        
        durationDetailContainer.drawCustomBorder(type: CUSTOM_BORDER_PRICE)
        
        selectDay.drawCustomBorder(type: CUSTOM_BORDER_DAY)
        
    }
    
    override func viewDidLayoutSubviews() {
        urlImages = (values as? [String: Any])!["photoUrls"] as? NSArray
        if(urlImages != nil){
            
            fieldImagesSlider.setUpView(imageSource: .Url(imageArray:urlImages as! [String],placeHolderImage:UIImage(named:"empty")),slideType:.ManualSwipe,isArrowBtnEnabled: true)
        }
        print("EnableArrows call------------------------")
        //init frame size for swipeview
        self.swipeMonthView!.frame = swipeViewFrame
        
        self.swipeDayView!.frame = swipeViewFrame
        self.swipeTimeView!.frame = swipeViewFrame
        
        //show white arrows of image slider
        self.fieldImagesSlider.showWhiteArrows()
    }
    
    func updateCellView(_ view: UIView, indexPath: IndexPath, isCurrent: Bool) {
        
        if let label = view as? FootballTagLabel {
            view.alpha = 0.8
            label.backgroundColor = isCurrent ? .white : .white
            
            //print(String(label.tag))
            if isCurrent {
                currentView?.backgroundColor = .white
                currentView = label
            }
            
            label.textAlignment = .center
            label.text = monthStrings[indexPath.row]
            print(monthStrings[indexPath.row])
            //label.setBorder(0.5, color: .black)
            
        } else if let footballView = view as? FootballTagView{
            //print("DAYCHOOSE" + String(indexPath.row + 1))
            view.alpha = 0.6
            if(footballView.footballTag == DAY_TAG){
                
                let weekDayLabel:UILabel = footballView.viewWithTag(SELECTDAY_WEEK) as! UILabel
                let dayLabel:UILabel = footballView.viewWithTag(SELECTDAY_DAY) as! UILabel
                
                var dayComponent = DateComponents()
                dayComponent.year = self.year
                dayComponent.month = self.month
                dayComponent.day = indexPath.row
                
                let userCalendar = Calendar.current
                
                let tempDay = userCalendar.date(from: dayComponent)!
                let dayOfWeek = userCalendar.component(.weekday, from: tempDay)
                
                weekDayLabel.text = weekDays[dayOfWeek - 1]
                
                dayLabel.text = String(indexPath.row + 1)
                
                if(isCurrent){
                    if(currentDayView != nil){
                        let prevWeekDayLabel:UILabel = currentDayView?.viewWithTag(SELECTDAY_WEEK) as! UILabel
                        let prevDayLabel:UILabel = currentDayView?.viewWithTag(SELECTDAY_DAY) as! UILabel
                        prevWeekDayLabel.textColor = UIColor.black
                        prevDayLabel.textColor = UIColor.black
                    }
                    weekDayLabel.textColor = UIColor.blue
                    dayLabel.textColor = UIColor.blue
                    currentDayView = view
                }
            }
            if(footballView.footballTag == TIME_TAG){
                view.alpha = 0.6
                let timeLabel: UILabel = footballView.viewWithTag(SELECTTIME_TIME) as! UILabel
                let image: UIImageView = footballView.viewWithTag(SELECTTIME_BALL) as! UIImageView
                image.contentMode = .scaleAspectFit
                
                let srcImage = UIImage(named: "ball")
                image.image =  srcImage?.maskWithColor(color: UIColor.black)
                
//                if(indexPath.row >= 12){
//                    //if noon 12 PM
//                    if(indexPath.row == 12){
//                        timeLabel.text = "12:00 PM"
//                    } else {
//                        timeLabel.text = String(indexPath.row - 12) + ":00 PM"
//                    }
//                } else {
//                    timeLabel.text = String(indexPath.row) + ":00 AM"
//                }
                timeLabel.text = String(indexPath.row + 5) + ":00 PM"
                if(isCurrent){
                    if(currentTimeView != nil){
                        let prevTimeLabel: UILabel = currentTimeView?.viewWithTag(SELECTTIME_TIME) as! UILabel
                        let prevImage:UIImageView = currentTimeView?.viewWithTag(SELECTTIME_BALL) as! UIImageView
                        prevTimeLabel.textColor = UIColor.black
                        prevImage.image = srcImage?.maskWithColor(color: UIColor.black)
                    }
                    timeLabel.textColor = UIColor.blue
                    image.image =  srcImage?.maskWithColor(color: UIColor.blue)
                    currentTimeView = view
                }
                
            }
        } else {
            assertionFailure("failed to retrieve UILabel for index: \(indexPath.row)")
        }
    }
    
    func didMovedToIndex(index:Int)
    {
        print("did moved at Index : ",index)
    }
}


extension FieldDetailPlayerController: HFSwipeViewDelegate {
    func swipeView(_ swipeView: HFSwipeView, didFinishScrollAtIndexPath indexPath: IndexPath) {
        log("HFSwipeView(\(swipeView.tag)) -> \(indexPath.row)")
        if(swipeView.tag == MONTH_TAG){
            print("finish scroll" + monthStrings[indexPath.row])
            self.month = indexPath.row + 1
            self.swipeMonthView.currentPage = indexPath.row
            self.swipeDayView.collectionView.reloadData()
            self.swipeDayView.layoutViews()
            
        } else if(swipeView.tag == DAY_TAG){
            print("Finish day choose" + String(indexPath.row + 1))
            self.day = indexPath.row
        } else if(swipeView.tag == TIME_TAG){
            print("Finish time choose" + String(indexPath.row + 1))
            self.time = indexPath.row
            
        }
        self.swipeMonthView.currentPage = indexPath.row
    }
    
    func swipeView(_ swipeView: HFSwipeView, didSelectItemAtPath indexPath: IndexPath) {
        log("HFSwipeView(\(swipeView.tag)) -> \(indexPath.row)")
        if(swipeView.tag == DAY_TAG){
            print("day choose" + String(indexPath.row + 1))
            self.day = indexPath.row
        } else if(swipeView.tag == TIME_TAG){
            print("time choose" + String(indexPath.row + 1))
            self.time = indexPath.row
        }
    }
    
    func swipeView(_ swipeView: HFSwipeView, didChangeIndexPath indexPath: IndexPath, changedView view: UIView) {
        log("HFSwipeView(\(swipeView.tag)) -> \(indexPath.row)")
    }
}

// MARK: - HFSwipeViewDataSource
extension FieldDetailPlayerController: HFSwipeViewDataSource {
    func swipeViewItemSize(_ swipeView: HFSwipeView) -> CGSize {
        if(swipeView.tag == MONTH_TAG){
            return itemMonthSize
        } else if(swipeView.tag == DAY_TAG){
            return itemDaySize
        } else if(swipeView.tag == TIME_TAG){
            return itemTimeSize
        } else{
            return itemSize
        }
    }
    func swipeViewItemCount(_ swipeView: HFSwipeView) -> Int {
        print("Reload called")
        if(swipeView.tag == MONTH_TAG){
            return sampleCount
        } else if(swipeView.tag == DAY_TAG){
            print("Reload called for day")
            let dateComponents = DateComponents(year: self.year, month: self.month)
            
            let calendar = Calendar.current
            
            let date = calendar.date(from: dateComponents)!
            
            let range = calendar.range(of: .day, in: .month, for: date)!
            let numDays = range.count
            
            return numDays
        } else if(swipeView.tag == TIME_TAG){
            return timesCount
        }else {
            return sampleCount
        }
    }
    func swipeView(_ swipeView: HFSwipeView, viewForIndexPath indexPath: IndexPath) -> UIView {
        
        if(swipeView.tag == MONTH_TAG){
            let view:FootballTagLabel = FootballTagLabel(frame: CGRect(origin: .zero, size: itemMonthSize))
            view.footballTag = swipeView.tag
            view.textAlignment = .center
            view.font = view.font.withSize(25)
            return view
        } else if(swipeView.tag == DAY_TAG){
            let view:FootballTagView = FootballTagView(frame: CGRect(origin: .zero, size: itemDaySize))
            view.footballTag = swipeView.tag
            let weekDayLabel = UILabel(frame: CGRect(origin: CGPoint(x:0, y: itemDaySize.height/2 - 16), size: CGSize(width: itemDaySize.width, height: 16)))
            weekDayLabel.textAlignment = .center
            weekDayLabel.tag = SELECTDAY_WEEK
            let dayLabel = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: itemDaySize.height / 2 - 3), size: CGSize(width: itemDaySize.width, height: itemDaySize.height / 2)))
            dayLabel.textAlignment = .center
            dayLabel.tag = SELECTDAY_DAY
            
            view.addSubview(weekDayLabel)
            view.addSubview(dayLabel)
            
            return view
        } else if(swipeView.tag == TIME_TAG){
            let view:FootballTagView = FootballTagView(frame: CGRect(origin: .zero, size: itemTimeSize))
            view.footballTag = swipeView.tag
            let ballImageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 8), size: CGSize(width: itemDaySize.width, height: itemDaySize.height / 2 - 5)))
            //ballImageView. = .center
            ballImageView.tag = SELECTTIME_BALL
            let timeLabel = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: itemDaySize.height / 2), size: CGSize(width: itemDaySize.width, height: itemDaySize.height / 2)))
            timeLabel.textAlignment = .center
            timeLabel.tag = SELECTTIME_TIME
            
            view.addSubview(ballImageView)
            view.addSubview(timeLabel)
            
            return view
        }
        else{
            let view:UIView = UIView(frame: CGRect(origin: .zero, size: itemSize))
            return view
        }
    }
    
    func swipeView(_ swipeView: HFSwipeView, needUpdateViewForIndexPath indexPath: IndexPath, view: UIView) {
        updateCellView(view, indexPath: indexPath, isCurrent: false)
    }
    func swipeView(_ swipeView: HFSwipeView, needUpdateCurrentViewForIndexPath indexPath: IndexPath, view: UIView) {
        updateCellView(view, indexPath: indexPath, isCurrent: true)
    }
}

