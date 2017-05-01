//
//  OrderFieldController.swift
//  Football
//
//  Created by Admin User on 3/16/17.
//  Copyright © 2017 prosunshining. All rights reserved.
//

import UIKit
import FirebaseDatabase
class OrderFieldController : UIViewController, UITextFieldDelegate{
    //order field information
    public var userId: String?
    public var fieldId: String?
    public var durationType: Int?
    public var dateTime: String?
    public var price: Int?
    public var totalPrice: Int?
    public var userName: String?
    public var year: Int?
    public var month: Int?
    public var day: Int?
    public var time: Int?
    
    //payment info for credit card
    @IBOutlet weak var cardHolderNameLabel: UITextField!
    @IBOutlet weak var cardNumberLabel: UITextField!
    @IBOutlet weak var cardTypeLabel: UITextField!
    @IBOutlet weak var expirationDateLabel: UITextField!
    @IBOutlet weak var cvcLabel: UITextField!
    
    //duration and amount
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var payButton: UIButton!
    override func viewDidLoad(){
        super.viewDidLoad()
        //make paybutton round rect
        payButton.layer.cornerRadius = 7
        
        //set duration label according to the duration type
        if(durationType == DURATION_60_MINUTES){
            durationLabel.text = "Duration: 60 minutes"
        } else if(durationType == DURATION_120_MINUTES){
            durationLabel.text = "Duration: 120 minutes"
        }
        //add done button to the keyboard
        cardHolderNameLabel.delegate = self
        cardHolderNameLabel.returnKeyType = .done
        cardNumberLabel.delegate = self
        cardNumberLabel.returnKeyType = .done
        cardTypeLabel.delegate = self
        cardTypeLabel.returnKeyType = .done
        expirationDateLabel.delegate = self
        expirationDateLabel.returnKeyType = .done
        cvcLabel.delegate = self
        cvcLabel.returnKeyType = .done
        //calculate total price
        if(durationType == DURATION_60_MINUTES){
            totalPrice = price
        } else if(durationType == DURATION_120_MINUTES){
            totalPrice = price! * 2
        }
        
        //get username from the delegate
        let delegate = UIApplication.shared.delegate as? AppDelegate
        userName = delegate?.user?["userName"] as? String
        //set price label according to the total price
        amountLabel.text = "Amount: " + String(totalPrice!)
    }
    
    @IBAction func orderField(_ sender: Any) {
        let ref = FIRDatabase.database().reference()
        let cardHolderName = cardHolderNameLabel.text
        let cardNumber = cardNumberLabel.text
        let cardType = cardTypeLabel.text
        let expirationDate = expirationDateLabel.text
        let cvc = cvcLabel.text
        let dateTime = "\(self.year!)-\(self.month!)-\(self.day!)-\(self.time!)"
        
        ref.child("orderNumber").observeSingleEvent(of: .value, with: {
            (snapshot) in
            let value = snapshot.value as? Int
            if let orderNumber = value{
                ref.child("field-schedule").child(self.fieldId!).child(dateTime).observeSingleEvent(of: .value, with: {
                    (snapshot) in
                    if(snapshot.exists()){
                        self.showToast(string: "Already ordered or not available");
                        return
                    } else {
                        ref.child("orders").child(String(orderNumber)).setValue(["userId": self.userId!
                            , "fieldId" : self.fieldId!
                            , "durationType" : self.durationType!
                            , "amount" : self.totalPrice!
                            , "dateTime" : dateTime
                            , "cardHolderName" : cardHolderName!
                            , "cardNumber" : cardNumber!
                            , "cardType" : cardType!
                            , "expirationDate": expirationDate!
                            , "cvc" : cvc!])
                        ref.child("orderNumber").setValue(value! + 1)
                        ref.child("field-schedule").child(self.fieldId!).child(dateTime).setValue([
                            "userName": self.userName!
                            , "type" : AVAILABLE
                            , "fieldId" : self.fieldId!
                            , "orderId" : String(orderNumber)
                            ])
                        if(self.durationType == DURATION_120_MINUTES){
                            let dateTime1 = "\(self.year!)-\(self.month!)-\(self.day!)-\(self.time! + 1)"
                            ref.child("field-schedule").child(self.fieldId!).child(dateTime1).setValue([
                                "type": AVAILABLE,
                                "userName": self.userName!
                                , "fieldId" : self.fieldId!
                                , "orderId" : String(orderNumber)
                                ])
                        }
                        self.performSegue(withIdentifier: "payConfirm", sender: orderNumber)

                    }
                })
            }
        })
    }
    
    @IBAction func onBackPressed(_ sender: Any) {
        navigationController?.popViewController(animated : true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "payConfirm"){
            let orderId = sender as! Int
            let confirmController = segue.destination as? PayConfirmController
            confirmController?.fieldId = self.fieldId!
            confirmController?.orderId = orderId
            confirmController?.year = self.year
            confirmController?.month = self.month
            confirmController?.day = self.day
            confirmController?.time = self.time
            confirmController?.durationType = self.durationType
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
