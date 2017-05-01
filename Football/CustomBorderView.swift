//
//  CustomBorderView.swift
//  Football
//
//  Created by Admin User on 3/8/17.
//  Copyright © 2017 prosunshining. All rights reserved.
//

import UIKit

extension UIView{
    func drawCustomBorder(type: Int){
        if(type == CUSTOM_BORDER_PRICE || type == CUSTOM_BORDER_DURATION){
            //draw top and bottom border
            let shape1   =  CAShapeLayer()
            let path1    =   UIBezierPath()
            path1.move(to: CGPoint(x:0, y:1))
            path1.addLine(to: CGPoint(x:self.frame.size.width,y:1))
            //path1.addLine(to: CGPoint(x:self.frame.size.width, y:1))
            shape1.lineWidth =   1.0
            shape1.path=path1.cgPath;
            shape1.fillColor=UIColor.clear.cgColor
            shape1.strokeColor   =   UIColor.black.withAlphaComponent(0.5).cgColor
            self.layer.addSublayer(shape1)
            
            let shape2   =  CAShapeLayer()
            let path2    =   UIBezierPath()
            path2.move(to: CGPoint(x:0, y:self.frame.size.height - 1))
            path2.addLine(to: CGPoint(x:self.frame.size.width, y:self.frame.size.height - 1))
            //path1.addLine(to: CGPoint(x:self.frame.size.width, y:1))
            shape2.lineWidth =   1.0
            shape2.path=path2.cgPath;
            shape2.fillColor=UIColor.clear.cgColor
            shape2.strokeColor   =   UIColor.black.withAlphaComponent(0.5).cgColor
            self.layer.addSublayer(shape2)
        }
        
        if(type == CUSTOM_BORDER_DAY){
            //draw top and bottom border
            let shape1   =  CAShapeLayer()
            let path1    =   UIBezierPath()
            path1.move(to: CGPoint(x:0, y:1))
            path1.addLine(to: CGPoint(x:self.frame.size.width,y:1))
            //path1.addLine(to: CGPoint(x:self.frame.size.width, y:1))
            shape1.lineWidth =   1.0
            shape1.path=path1.cgPath;
            shape1.fillColor=UIColor.clear.cgColor
            shape1.strokeColor   =   UIColor.black.withAlphaComponent(0.9).cgColor
            self.layer.addSublayer(shape1)
            
            let shape2   =  CAShapeLayer()
            let path2    =   UIBezierPath()
            path2.move(to: CGPoint(x:0, y:self.frame.size.height - 2))
            path2.addLine(to: CGPoint(x:self.frame.size.width, y:self.frame.size.height - 2))
            //path1.addLine(to: CGPoint(x:self.frame.size.width, y:1))
            shape2.lineWidth =   1.0
            shape2.path=path2.cgPath;
            shape2.fillColor=UIColor.clear.cgColor
            shape2.strokeColor   =   UIColor.black.withAlphaComponent(0.9).cgColor
            self.layer.addSublayer(shape2)
        }
    }
}
