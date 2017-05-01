//
//  FieldEditController.swift
//  Football
//
//  Created by Admin User on 3/10/17.
//  Copyright © 2017 prosunshining. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import LocationPicker
import CoreLocation
import MapKit
import ALLoadingView
class FieldEditController: UIViewController, UIImagePickerControllerDelegate, UIPopoverPresentationControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate,  ChooseImageSourceControllerDelegate{
    
    @IBAction func onBackPressed(_ sender: Any) {
        navigationController?.popViewController(animated : true)
    }
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    @IBOutlet weak var fieldName: UITextField!
    @IBOutlet weak var cityName: UITextField!
    
    @IBOutlet weak var locationName: UITextField!
    
    @IBOutlet weak var locationPickerButton: UIButton!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var uploadPictureButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var pickLocationButton: UIButton!
    public var longitude: CLLocationDegrees?
    public var latitude: CLLocationDegrees?
    public var userId: String = ""
    public var photoUrls:[String] = []
    
    //edit mode or add new field mode
    public var mode = ADD_MODE
    public var fieldId = ""
    
    //values that contains all information for one field
    public var values : NSDictionary?
    let picker = UIImagePickerController()
    
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //replace footballer logo with navigation bar title
        let image = UIImage(named: "footballer_medium")
        self.navigationItem.titleView = UIImageView(image: image)
        uploadPictureButton.layer.cornerRadius = 7
        pickLocationButton.layer.cornerRadius = 7
        saveButton.layer.cornerRadius = 7
        imagePickerView.layer.cornerRadius = 7
        imagePickerView.layer.borderColor = UIColor.black.cgColor
        imagePickerView.layer.borderWidth = 1
        
        //add done button to the keyboard
        cityName.delegate = self
        cityName.returnKeyType = .done
        locationName.delegate = self
        locationName.returnKeyType = .done
        fieldName.delegate = self
        fieldName.returnKeyType = .done
        price.delegate = self
        price.returnKeyType = .done
        
        //imagePickerView tag gesture to pick photo
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))

        imagePickerView.isUserInteractionEnabled = true
        imagePickerView.addGestureRecognizer(tapGestureRecognizer)
        picker.delegate = self
        
        //load data from the values if it is to edit field now
        if(self.mode == EDIT_MODE && values != nil){
            cityName.text = values?["cityName"] as! String?
            fieldName.text = values?["fieldName"] as! String?
            locationName.text = values?["locationName"] as! String?
            userId = values?["fieldOwner"] as! String!
            longitude = values?["longitude"] as! Double?
            latitude = values?["latitude"] as! Double?
            price.text = String(values?["price"] as! Int)
            if(values?["photoUrls"] as? [String] != nil){
                photoUrls = (values?["photoUrls"] as? [String])!
            }
            
        }
    }
    

    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        imagePickerView.contentMode = .scaleAspectFit //3
        imagePickerView.image = chosenImage //4
        dismiss(animated:true, completion: nil) //5
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated:true, completion: nil)
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        if(tappedImage == imagePickerView){
            //performSegue(withIdentifier: "chooseImageSource", sender: self)
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "chooseImageSource") as! ChooseImageSourceController
            
            //delegate for image picker
            vc.delegate = self
            
            vc.modalPresentationStyle = .popover
            let popover = vc.popoverPresentationController!
            popover.delegate = self
            
            popover.sourceView = self.imagePickerView
            popover.sourceRect = self.imagePickerView.bounds
            
            self.present(vc, animated: true, completion: nil)
        }
        
        // Your action
    }
    @IBAction func uploadPhoto(_ sender: Any) {
        
        
        // Get a reference to the storage service using the default Firebase App
        let storage = FIRStorage.storage()
        
        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        
        let fileName = UUID().uuidString.lowercased()
        
        // Create a child reference
        // imagesRef now points to "images"
        let imageRef = storageRef.child(fileName)
        
        guard imagePickerView.image != nil else {
            return
        }
        let data = UIImagePNGRepresentation(imagePickerView.image!)
        
        ALLoadingView.manager.showLoadingView(ofType: .basic, windowMode: .fullscreen)
        _ = imageRef.put(data!, metadata: nil) { (metadata, error) in
            ALLoadingView.manager.hideLoadingView()
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            let downloadURL = metadata.downloadURL()? .absoluteString
            self.photoUrls.append(downloadURL!)
            
        }
    }
    func imageDidPick(image: UIImage) {
        imagePickerView.contentMode = .scaleAspectFit
        imagePickerView.image = image
        
    }
    
    func imageDidCancel() {
        
    }
    @IBAction func pickLocation(_ sender: Any) {
        let locationPicker = LocationPickerViewController()
        let coordinates = CLLocationCoordinate2D(latitude: 43.25, longitude: 76.95)
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: [:])
       
        let location = Location(name: "Test", location: nil,
                            placemark: placemark)
        locationPicker.location = location
        locationPicker.showCurrentLocationButton = true
        locationPicker.useCurrentLocationAsHint = true
        locationPicker.showCurrentLocationInitially = true
        
        locationPicker.completion = {
            location in
            let address = (location?.placemark.addressDictionary) as? [String: Any]
            self.cityName.text = address?["City"] as? String
            self.locationName.text = address?["Name"] as? String
            self.latitude = location?.location.coordinate.latitude
            self.longitude = location?.location.coordinate.longitude 
        }
        navigationController?.pushViewController(locationPicker, animated: true)
    }
    @IBAction func saveField(_ sender: Any) {
        if(self.longitude == nil || self.latitude == nil) {
            return
            
        }
        let field = Field(fieldName: self.fieldName.text!, locationName: self.locationName.text!, cityName: self.cityName.text!, fieldOwner: self.userId, price: Int(self.price.text!)!, longitude: self.longitude!, latitude: self.latitude!, photoUrls: self.photoUrls as NSArray)
        let ref = FIRDatabase.database().reference()
        //add or update
        if(self.mode == ADD_MODE || fieldId == ""){
            ref.child("fields").childByAutoId().setValue(field.getField())
        }else{
            ref.child("fields").child(fieldId).setValue(field.getField())
        }
        navigationController?.popToRootViewController(animated: true)
        
        if let topController = UIApplication.topViewController() {
            
            let fieldListViewController = UIApplication.topViewController() as! FieldListViewController
            fieldListViewController.reloadTable()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
