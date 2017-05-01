//
//  SwipeExtension.swift
//  Football
//
//  Created by Admin User on 3/15/17.
//  Copyright © 2017 prosunshining. All rights reserved.
//

import UIKit
import HFSwipeView
extension HFSwipeView{
    func enableArrows()
    {
        print("EnableArrows called")
        
        
        let shape1   =  CAShapeLayer()
        let path1    =   UIBezierPath()
        path1.move(to: CGPoint(x:self.frame.size.width-25, y:self.collectionView.frame.size.height/2-10))
        path1.addLine(to: CGPoint(x:self.frame.size.width-17,y: self.collectionView.frame.size.height/2))
        path1.addLine(to: CGPoint(x:self.frame.size.width-25, y:self.collectionView.frame.size.height/2+10))
        shape1.lineWidth =   4.0
        shape1.path=path1.cgPath;
        shape1.fillColor=UIColor.clear.cgColor
        shape1.strokeColor   =   UIColor.black.withAlphaComponent(0.5).cgColor
        self.layer.addSublayer(shape1)
        
        let shape2   =  CAShapeLayer()
        let path2    =   UIBezierPath()
        path2.move(to: CGPoint(x:25, y:self.collectionView.frame.size.height/2-10))
        path2.addLine(to: CGPoint(x:17,y: self.collectionView.frame.size.height/2))
        path2.addLine(to: CGPoint(x:25, y:self.collectionView.frame.size.height/2+10))
        shape2.lineWidth =  4.0
        shape2.path=path2.cgPath;
        shape2.fillColor=UIColor.clear.cgColor
        shape2.strokeColor   =   UIColor.black.withAlphaComponent(0.5).cgColor
        self.layer.addSublayer(shape2)
        
        let leftBtn    =   UIButton()
        leftBtn.frame  =   CGRect(x:6,y: self.collectionView.frame.size.height/2-15,width: 20,height: 30)
        
        
        leftBtn.addTarget(self, action: #selector(HFSwipeView.swipeLeft), for: .touchUpInside)
        self.addSubview(leftBtn)
        
        let rightBtn    =   UIButton()
        rightBtn.frame  =   CGRect(x:self.frame.size.width-26, y:self.collectionView.frame.size.height/2-15,width: 20, height:30)
        rightBtn.addTarget(self, action: #selector(HFSwipeView.swipeRight), for: .touchUpInside)
        self.addSubview(rightBtn)
        
    }
    
    func swipeLeft(){
        
        
        var month:Int?
        if let scheduleController = self.dataSource as? ScheduleController{
            month = scheduleController.month
        }
        if let availibilityController = self.dataSource as? AvailibilityController{
            month = availibilityController.month
        }
        if let fieldDetailPlayerController = self.dataSource as? FieldDetailPlayerController{
            month = fieldDetailPlayerController.month
        }
        
        if(month! > 1){
            month = month! - 1
            let indexPath:IndexPath = IndexPath(row: month! - 1, section: 0)
            self.currentPage = month! - 1
            self.collectionView(self.collectionView, didSelectItemAt: indexPath)
            self.delegate?.swipeView!(self, didFinishScrollAtIndexPath: indexPath)
        }
    }
    func swipeRight(){
        var month:Int?
        if let scheduleController = self.dataSource as? ScheduleController{
            month = scheduleController.month
        }
        if let availibilityController = self.dataSource as? AvailibilityController{
            month = availibilityController.month
        }
        if let fieldDetailPlayerController = self.dataSource as? FieldDetailPlayerController{
            month = fieldDetailPlayerController.month
        }
        
        if(month! < self.count){
            month = month! + 1
            let indexPath:IndexPath = IndexPath(row: month! - 1, section: 0)
            self.currentPage = month! - 1
            self.collectionView(self.collectionView, didSelectItemAt: indexPath)
            self.delegate?.swipeView!(self, didFinishScrollAtIndexPath: indexPath)
        }
    }
}
