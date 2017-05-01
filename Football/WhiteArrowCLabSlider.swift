//
//  WhiteArrowCLabSlider.swift
//  Football
//
//  Created by Admin User on 3/7/17.
//  Copyright © 2017 prosunshining. All rights reserved.
//

import Foundation
import UIKit
import CLabsImageSlider
extension CLabsImageSlider{
    
    func showWhiteArrows(){
        let shape   =  CAShapeLayer()
        let path    =   UIBezierPath()
        path.move(to: CGPoint(x:self.frame.size.width-18, y:self.frame.size.height/2-10))
        path.addLine(to: CGPoint(x:self.frame.size.width-10,y: self.frame.size.height/2))
        path.addLine(to: CGPoint(x:self.frame.size.width-18,y: self.frame.size.height/2+10))
        shape.lineWidth =   3.0
        shape.path=path.cgPath;
        shape.fillColor=UIColor.clear.cgColor
        shape.strokeColor   =   UIColor.white.cgColor
        self.layer.addSublayer(shape)
        
        let shape2   =  CAShapeLayer()
        let path2    =   UIBezierPath()
        path2.move(to: CGPoint(x:18, y:self.frame.size.height/2-10))
        path2.addLine(to: CGPoint(x:10, y:self.frame.size.height/2))
        path2.addLine(to: CGPoint(x:18, y:self.frame.size.height/2+10))
        shape2.lineWidth =   3.0
        shape2.path=path2.cgPath;
        shape2.fillColor=UIColor.clear.cgColor
        shape2.strokeColor   =   UIColor.white.cgColor
        self.layer.addSublayer(shape2)
        
    }
}
