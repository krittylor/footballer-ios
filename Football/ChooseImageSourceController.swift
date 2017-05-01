//
//  ChooseImageSourceController.swift
//  Football
//
//  Created by Admin User on 3/15/17.
//  Copyright © 2017 prosunshining. All rights reserved.
//
import UIKit

protocol ChooseImageSourceControllerDelegate{
    func imageDidPick(image: UIImage) -> Void
    func imageDidCancel() -> Void
}

class ChooseImageSourceController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    let picker = UIImagePickerController()
    public var delegate: ChooseImageSourceControllerDelegate? = nil

    @IBAction func cancelImagePick(_ sender: Any) {
        dismissSelf()
    }
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
        self.automaticallyAdjustsScrollViewInsets = true
    }
    @IBAction func chooseLibrary(_ sender: Any) {
        showLibraryImagePicker()
        //dismiss(animated: true, completion: nil)
    }
    @IBAction func chooseCamera(_ sender: Any) {
        showCameraImagePicker()
        //dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.progressLoading.setProgress(1.0, animated: true)
        // Do any additional setup after loading the view, typically from a nib.
        
        picker.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showLibraryImagePicker(){
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    func showCameraImagePicker(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker,animated: true,completion: nil)
        } else {
            noCamera()
        }
    }
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        delegate?.imageDidPick(image: chosenImage)
        dismiss(animated:true, completion: nil) //5
        dismissSelf()
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        dismissSelf()
    }
    
    func dismissSelf(){
        dismiss(animated: true, completion: nil)
    }
}
