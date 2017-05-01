//
//  ToastUIViewController.swift
//  Football
//
//  Created by Admin User on 3/4/17.
//  Copyright © 2017 prosunshining. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    func showToast(string : String){
        let toastLabel = UILabel(frame: CGRect(x:self.view.frame.size.width/2 - 150, y:self.view.frame.size.height-100, width:300, height:35))
        toastLabel.backgroundColor = UIColor.black
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = NSTextAlignment.center;
        self.view.addSubview(toastLabel)
        toastLabel.text = string
        toastLabel.alpha = 0.8
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            toastLabel.alpha = 0.0
            
        })
    }
}
