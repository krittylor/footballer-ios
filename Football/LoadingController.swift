//
//  ViewController.swift
//  Football
//
//  Created by Admin User on 3/2/17.
//  Copyright © 2017 prosunshining. All rights reserved.
//

import UIKit

class LoadingController: UIViewController {
    @IBOutlet weak var progressLoading: UIProgressView!
    var time:Double = 0.0
    var timer: Timer!
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.progressLoading.setProgress(1.0, animated: true)
        // Do any additional setup after loading the view, typically from a nib.
        
        time = 0.0

        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector:#selector(setProgress), userInfo: nil, repeats: true)
        
        
    
    }
    func setProgress() {
        time += 0.05
        progressLoading.setProgress(Float(time / 3.0), animated : true)
        if time >= 3 {
            timer.invalidate()
            performSegue(withIdentifier:"loadingtosplash", sender: self)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
