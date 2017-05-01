//
//  Profile.swift
//  Football
//
//  Created by Admin User on 3/14/17.
//  Copyright © 2017 prosunshining. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import ALLoadingView
class ProfileController: UIViewController, UIPopoverPresentationControllerDelegate, ChooseImageSourceControllerDelegate {
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameEdit: UILabel!
    @IBOutlet weak var mobileEdit: UILabel!
    @IBOutlet weak var birthdayEdit: UILabel!
    @IBOutlet weak var emailEdit: UILabel!
    //image picker
    let imagePicker = UIImagePickerController()
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func editButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "editProfile", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load data from user saved in AppDelegate
        let delegate = UIApplication.shared.delegate as! AppDelegate
        emailEdit.text = FIRAuth.auth()?.currentUser?.email
        if(delegate.user?["birthday"] as! String? != ""){
            birthdayEdit.text = delegate.user?["birthday"] as! String?
        }
        if(delegate.user?["phoneNumber"] as! String? != ""){
            mobileEdit.text = delegate.user?["phoneNumber"] as! String?
        }
        if(delegate.user?["userName"] as! String? != ""){
            userNameEdit.text = delegate.user?["userName"] as! String?
        }
        
        
        //image picker for avatar
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGestureRecognizer)
        
        //load avatar image for the user
        let ref = FIRDatabase.database().reference()
        ref.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).observeSingleEvent(of: .value, with: {(snapshot) in
            let values = snapshot.value as? NSDictionary
            let photoUrl = values?["photoUrl"] as? String
            if(photoUrl != nil && photoUrl != ""){
                let url = URL(string: photoUrl!)
                self.avatarImageView.sd_setShowActivityIndicatorView(true)
                self.avatarImageView.sd_setIndicatorStyle(.gray)
                self.avatarImageView.sd_setImage(with: url)
            }
        })
        
        //logout button corner radius
        logoutButton.layer.cornerRadius = 7
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        if(tappedImage == avatarImageView){
            //performSegue(withIdentifier: "chooseImageSource", sender: self)
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "chooseImageSource") as! ChooseImageSourceController
            
            //delegate for image picker
            vc.delegate = self
            
            vc.modalPresentationStyle = .popover
            let popover = vc.popoverPresentationController!
            popover.delegate = self
            
            popover.sourceView = self.avatarImageView
            popover.sourceRect = self.avatarImageView.bounds
            
            self.present(vc, animated: true, completion: nil)
        }
        
        // Your action
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    func uploadPhoto(image : UIImage) {
        
        
        // Get a reference to the storage service using the default Firebase App
        let storage = FIRStorage.storage()
        
        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        
        let fileName = UUID().uuidString.lowercased()
        
        // Create a child reference
        // imagesRef now points to "images"
        let imageRef = storageRef.child(fileName)
        
        let data = UIImagePNGRepresentation(image)
        
        ALLoadingView.manager.showLoadingView(ofType: .basic, windowMode: .fullscreen)
        _ = imageRef.put(data!, metadata: nil) { (metadata, error) in
            ALLoadingView.manager.hideLoadingView()
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            let downloadURL = metadata.downloadURL()? .absoluteString
            //update photoUrl of the user
            let ref = FIRDatabase.database().reference()
            let uid = FIRAuth.auth()?.currentUser?.uid
            ref.child("users").child(uid!).child("photoUrl").setValue(downloadURL)
        }
    }
    
    func imageDidPick(image: UIImage) {
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.image = image
        
        //upload avatar and save photoUrl
        uploadPhoto(image: image)
    }
    
    func imageDidCancel() {
        
    }
    
    
    @IBAction func logOut(_ sender: Any) {
        try! FIRAuth.auth()!.signOut()
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "joinCommunityBoard")
        self.present(vc, animated: false, completion: nil)
    }
}
