//
//  JWColor.swift
//  JWKitLearn
//
//  Created by njdby on 16/1/5.
//  Copyright © 2016年 njdby. All rights reserved.
//

import Foundation
import UIKit

public struct RGBA {
    var red : CGFloat = 0.0
    var green : CGFloat = 0.0
    var blue : CGFloat = 0.0
    var alpha  : CGFloat = 0.0
}

extension UIColor {
    
    var red: CGFloat {
        get {
            let components = CGColorGetComponents(self.CGColor)
            return components[0]
        }
    }
    
    var green: CGFloat {
        get {
            let components = CGColorGetComponents(self.CGColor)
            return components[1]
        }
    }
    
    var blue: CGFloat {
        get {
            let components = CGColorGetComponents(self.CGColor)
            return components[2]
        }
    }
    
    var alpha: CGFloat {
        get {
            return CGColorGetAlpha(self.CGColor)
        }
    }
    
    func alpha(alpha: CGFloat) -> UIColor {
        return UIColor(red: self.red, green: self.green, blue: self.blue, alpha: alpha)
    }
    
    func white(scale: CGFloat) -> UIColor {
        return UIColor(
            red: self.red + (1.0 - self.red) * scale,
            green: self.green + (1.0 - self.green) * scale,
            blue: self.blue + (1.0 - self.blue) * scale,
            alpha: 1.0
        )
    }
    
    func getRGBA() -> [Float]
    {
        func zeroIfDodgy(value: Float) ->Float
        {
            return isnan(value) || isinf(value) ? 0 : value
        }
        
        if CGColorGetNumberOfComponents(self.CGColor) == 4
        {
            let colorRef = CGColorGetComponents(self.CGColor);
            
            let redComponent = (zeroIfDodgy(Float(colorRef[0])))
            let greenComponent = (zeroIfDodgy(Float(colorRef[1])))
            let blueComponent = (zeroIfDodgy(Float(colorRef[2])))
            let alphaComponent = (zeroIfDodgy(Float(colorRef[3])))
            
            return [redComponent, greenComponent, blueComponent, alphaComponent]
        }
        else if CGColorGetNumberOfComponents(self.CGColor) == 2
        {
            let colorRef = CGColorGetComponents(self.CGColor);
            
            let greyComponent = (zeroIfDodgy(Float(colorRef[0])))
            let alphaComponent = (zeroIfDodgy(Float(colorRef[1])))
            
            return [greyComponent, greyComponent, greyComponent, alphaComponent]
        }
        else
        {
            return [0,0,0,0]
        }
    }
    
    
    func getHex() -> String
    {
        let rgb = self.getRGBA()
        
        let red = NSString(format: "%02X", Int(rgb[0] * 255))
        let green = NSString(format: "%02X", Int(rgb[1] * 255))
        let blue = NSString(format: "%02X", Int(rgb[2] * 255))
        
        return (red as String) + (green as String) + (blue as String)
    }
    /**
     colorWithRGBHex(0x209624)
     */
    func colorWithRGBHex(hex:UInt) -> UIColor {
        return UIColor(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    func randomColor() -> UIColor {

        let hue : CGFloat = CGFloat(arc4random() % 256) / 256
        let saturation : CGFloat = CGFloat(arc4random() % 89) / 256 + 0.35
        let brightness : CGFloat = CGFloat(arc4random() % 89) / 256 + 0.35
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
    
    class func randomColor(alpha:CGFloat = 1.0) -> UIColor {
        var red:CGFloat = 0.0, green:CGFloat = 0.0, blue:CGFloat = 0.0
        var generated = false
        if generated == false {
            generated = true
            srandom(CUnsignedInt(time(nil)))
        }
        red = CGFloat(random())/CGFloat(RAND_MAX)
        green = CGFloat(random())/CGFloat(RAND_MAX)
        blue = CGFloat(random())/CGFloat(RAND_MAX)
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
