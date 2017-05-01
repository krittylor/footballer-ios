//
//  ScheduleController.swift
//  Football
//
//  Created by Admin User on 3/15/17.
//  Copyright © 2017 prosunshining. All rights reserved.
//

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
import FirebaseDatabase
class ScheduleController: UIViewController {
    
    @IBOutlet weak var selectDateButton: UIButton!
    @IBOutlet weak var selectMonth: UIView!
    @IBOutlet weak var selectTime: UIView!
    @IBOutlet weak var selectDay: UIView!
    //store fieldid
    public var fieldId: String?
    public var fieldName: String = ""
    
    fileprivate let MONTH_TAG = 0x01
    fileprivate let DAY_TAG = 0x02
    fileprivate let TIME_TAG = 0x03
    fileprivate let SELECTDAY_WEEK = 0x04
    fileprivate let SELECTDAY_DAY = 0x05
    fileprivate let SELECTTIME_TIME = 0x06
    fileprivate let SELECTTIME_BALL = 0x07
    //choose month section
    fileprivate let sampleCount: Int = 12
    fileprivate var swipeMonthView: HFSwipeView!
    fileprivate var itemSize: CGSize {
        return CGSize(width: self.view.frame.size.width, height: self.selectDay.frame.size.height)
    }
    fileprivate var itemMonthSize: CGSize {
        return CGSize(width: self.view.frame.size.width, height: self.selectMonth.frame.size.height)
    }
    fileprivate var swipeMonthViewFrame: CGRect {
        return CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 100)
    }
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    fileprivate var currentView: UIView?
    
    //choose day section
    fileprivate var swipeDayView: HFSwipeView!
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
    //date info
    public var year: Int?
    public var month: Int?
    public var day: Int?
    public var time: Int?

    
    //order data to be passed to orderresult
    public var scheduleType: String?
    public var userName: String?
    public var orderId: String?
    
    
    fileprivate var swipeViewFrame: CGRect {
        return CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 100)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.automaticallyAdjustsScrollViewInsets = true
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //replace text of the title bar
        self.title = self.fieldName
        
        //round cornor button
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
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.swipeMonthView!.enableArrows()
        
        selectDay.drawCustomBorder(type: CUSTOM_BORDER_DAY)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "orderDetail"){
            let orderResultController = segue.destination as! OrderResultController
            orderResultController.scheduleType = self.scheduleType!
            orderResultController.customerName = self.userName!
            orderResultController.orderId = self.orderId!
        }
    }
    
    @IBAction func selectDateAndTimePressed(_ sender: Any) {
        let ref = FIRDatabase.database().reference()
        let dateString = "\(self.year!)-\(self.month!)-\(self.day! + 1)-\(self.time! + 5)"
        ref.child("field-schedule").child(self.fieldId!).child(dateString).observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let values = snapshot.value as? NSDictionary{
                if let type = values["type"] as? Int{
                    if(type == NOT_AVAILABLE){
                        self.scheduleType = "na"
                        self.orderId = ""
                        self.userName = ""
                        self.performSegue(withIdentifier: "orderDetail", sender: self)
                    }
                } else {
                    self.scheduleType = "order"
                    self.orderId = values["orderId"] as? String
                    self.userName = values["userName"] as? String
                    self.performSegue(withIdentifier: "orderDetail", sender: self)
                }
            } else {
                self.scheduleType = "not yet"
                self.orderId = ""
                self.userName = ""
                self.performSegue(withIdentifier: "orderDetail", sender: self)
            }
        })
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    override func viewDidLayoutSubviews() {
        
        print("EnableArrows call------------------------")
        //init frame size for swipeview
        self.swipeMonthView!.frame = swipeViewFrame
        
        self.swipeDayView!.frame = swipeViewFrame
        self.swipeTimeView!.frame = swipeViewFrame

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
                timeLabel.text = String(indexPath.row + 5) + ":00 PM";
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
}


extension ScheduleController: HFSwipeViewDelegate {
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
extension ScheduleController: HFSwipeViewDataSource {
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
            let weekDayLabel = UILabel(frame: CGRect(origin: CGPoint(x:0, y: 0), size: CGSize(width: itemDaySize.width, height: 14)))
            weekDayLabel.textAlignment = .center
            weekDayLabel.tag = SELECTDAY_WEEK
            let dayLabel = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: 16), size: CGSize(width: itemDaySize.width, height: 14)))
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
