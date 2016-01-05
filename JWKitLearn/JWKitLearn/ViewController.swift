//
//  ViewController.swift
//  JWKitLearn
//
//  Created by njdby on 16/1/5.
//  Copyright © 2016年 njdby. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("今年:\(NSDate().year())");
        print("今年:\(NSDate().firstWeekDayInMonth())");
        print("今年:\(NSDate().dateEndOfWeek())");
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

