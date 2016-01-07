//
//  JWDate.swift
//  JWKitLearn
//
//  Created by njdby on 16/1/5.
//  Copyright © 2016年 njdby. All rights reserved.
//
// MARK: - 时间换算
import Foundation

extension NSDate {
    func year() -> Int {
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let components: NSDateComponents = gregorian.components(.Year, fromDate: self)
        return components.year
    }
    func month() -> Int {
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let components: NSDateComponents = gregorian.components(.Month, fromDate: self)
        return components.month;
    }
    func day() -> Int{
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let components: NSDateComponents = gregorian.components(.Day, fromDate: self)
        return components.day;
    }

    /**
     当前月的第一天是星期几
    
    - returns: 数字0-6
    */
    func firstWeekDayInMonth() -> Int {
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        gregorian.firstWeekday = 2
        let comps: NSDateComponents = gregorian.components([NSCalendarUnit.Year,NSCalendarUnit.Month,NSCalendarUnit.Day], fromDate: self)
            comps.day = 1
        let newDate = gregorian.dateFromComponents(comps)
        return gregorian.ordinalityOfUnit(.Weekday, inUnit: .WeekOfMonth, forDate: newDate!)
    }
    /**
     时隔几个月后的日期
     
     - parameter numMonths: 月数
     
     - returns: 时间
     */
    func offsetMonth(numMonths:Int) ->NSDate {
        
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        gregorian.firstWeekday = 2;
        let offsetComponents = NSDateComponents()
        offsetComponents.month = numMonths
        return gregorian.dateByAddingComponents(offsetComponents, toDate: self, options: .WrapComponents)!
    }
    
    
    func offsetDay(numDays:Int) -> NSDate {
        
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        gregorian.firstWeekday = 2;
        let offsetComponents = NSDateComponents()
        offsetComponents.day = numDays
        return gregorian.dateByAddingComponents(offsetComponents, toDate: self, options: .WrapComponents)!
    }
    
    /**
     当月天数
     
     - returns: 当月天数
     */
    func numDaysInMonth() ->Int {

        let cal = NSCalendar.currentCalendar()
        let rng = cal.rangeOfUnit(.Day, inUnit: .Month, forDate: self)
        let numberOfDaysInMoth = rng.length
        return numberOfDaysInMoth
    }
    
    func dateStartOfDay(date:NSDate) ->NSDate {
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let components = gregorian.components([NSCalendarUnit.Year,NSCalendarUnit.Month,NSCalendarUnit.Day], fromDate: date)
        return gregorian.dateFromComponents(components)!
    }
    /**
     一个星期之前的日期
     
     - returns: 
     */
    func dateStartOfWeek() -> NSDate {
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        gregorian.firstWeekday = 2;
        
      let components = NSCalendar.currentCalendar().components(.Weekday, fromDate: NSDate())
        
        let componentsToSubtract = NSDateComponents()
        
        componentsToSubtract.day = -(((components.weekday - gregorian.firstWeekday)+7) % 7)
        
        var beginningOfWeek = gregorian.dateByAddingComponents(componentsToSubtract, toDate:self, options: .WrapComponents)
        
        let componentsSripped = gregorian.components([NSCalendarUnit.Year,NSCalendarUnit.Month,NSCalendarUnit.Day], fromDate: beginningOfWeek!)
        
        beginningOfWeek = gregorian.dateFromComponents(componentsSripped)
        
        return beginningOfWeek!
    }
    /**
     一个星期后的日期
     
     - returns:
     */
    func dateEndOfWeek() -> NSDate {
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        gregorian.firstWeekday = 2;
        
        let components = NSCalendar.currentCalendar().components(.Weekday, fromDate: NSDate())
        
        let componentsToAdd = NSDateComponents()
        
        
        print("\((components.weekday - gregorian.firstWeekday) + 7))");
        
        componentsToAdd.day = +((((components.weekday - gregorian.firstWeekday + 7) % 7)) + 6)
        
        var endOfWeek = gregorian.dateByAddingComponents(componentsToAdd, toDate: self, options: .WrapComponents)
        
        let componentsSripped = gregorian.components([NSCalendarUnit.Year,NSCalendarUnit.Month,NSCalendarUnit.Day], fromDate: endOfWeek!)
        
        endOfWeek = gregorian.dateFromComponents(componentsSripped)
        
        return endOfWeek!
    }
    
}