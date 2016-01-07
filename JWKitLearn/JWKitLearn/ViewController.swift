//
//  ViewController.swift
//  JWKitLearn
//
//  Created by njdby on 16/1/5.
//  Copyright © 2016年 njdby. All rights reserved.
//

import UIKit

class ViewController: UIViewController,JWCalendarItemDelegate {
    
    var v:JWCalendarItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        v = JWCalendarItem();
        v!.date = NSDate()
        v!.delegate = self
//        self.view.addSubview(v!)
        
        char(twinsts, a: 12, b: 3)
        
        let test:(Int,Int) -> Int = {(a,b) in a + b}

        print("\(test(12,123))")
        
        let jw = JWCalendar(date: NSDate())
        self.view.addSubview(jw)
    }

    func calendarItem(item:JWCalendarItem,date:NSDate) -> Void {
        v?.date = date
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func char(towInsts:(Int,Int) -> Int,a:Int,b:Int)-> Void {
            towInsts(a,b)
    }
    func twinsts(a:Int,b:Int) -> Int{
        return a + b
    }

}

