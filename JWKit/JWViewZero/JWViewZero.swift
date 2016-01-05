//
//  JWViewZero.swift
//  JWKitLearn
//
//  Created by njdby on 16/1/5.
//  Copyright © 2016年 njdby. All rights reserved.
//
/**
*  坐标转换
*/
import Foundation
import UIKit

extension UIView {
    
    var frameOrigin:CGPoint {
        set {
            self.frame = CGRectMake(newValue.x, newValue.y, self.frame.size.width, self.frame.height)
        }
        get {
            return self.frame.origin
        }
        
    }
    var frameSize:CGSize{
        set {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newValue.width,newValue.height)
        }
        get {
            return self.frame.size
        }
    }
    var frameX:CGFloat{
        set {
            self.frame = CGRectMake(newValue, self.frame.origin.y, self.frame.size.width, self.frame.size.height)
        }
        get {
            return self.frame.origin.x
        }
    }
    
    var frameY:CGFloat{
        set {
            self.frame = CGRectMake(self.frame.origin.y,newValue, self.frame.size.width, self.frame.size.height)
        }
        get {
            return self.frame.origin.y
        }
    }
    var framgeRight:CGFloat{
        set {
            self.frame = CGRectMake(newValue - self.frame.size.width, self.frame.origin.y,
                self.frame.size.width, self.frame.size.height)
        }
        get {
            return self.frame.origin.x + self.frame.size.width
        }
    }
    var frameBottom:CGFloat{
        set {
            self.frame = CGRectMake(self.frame.origin.x, newValue - self.frame.size.height,
                self.frame.size.width, self.frame.size.height)
        }
        get {
            return self.frame.origin.y + self.frame.size.height
        }
    }

    var frameWidth:CGFloat{
        
        set {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newValue, self.frame.size.height)
        }
        
        get {
            return self.frame.width
        }
    }

    var frameHeight:CGFloat{
        set {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, newValue)
        }
        get {
            return self.frame.height
        }
    }
    func containsSubView(subView:UIView) -> Bool {
        
        for view in self.subviews {
            if view.isEqual(subView) {
                return true
            }
        }
        return false
    }
}