//
//  JWCalendarItem.swift
//  JWKitLearn
//
//  Created by njdby on 16/1/6.
//  Copyright © 2016年 njdby. All rights reserved.
//

import Foundation
import UIKit
protocol JWCalendarItemDelegate {
    func calendarItem(item:JWCalendarItem,date:NSDate) -> Void
}



class JWCalendarCell:UICollectionViewCell {
    var dayLabel:UILabel! //感叹号去掉需要在super.init()之前初始化
    var chineseDayLabel:UILabel!  //添加感叹号说明已经初始化
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        dayLabel = UILabel(frame: CGRectMake(0, 0, 20, 20))
        chineseDayLabel = UILabel(frame: CGRectMake(0,0,20,10))
        dayLabel.textAlignment = .Center
        dayLabel.font = UIFont.systemFontOfSize(15)
        dayLabel.center = CGPointMake(self.bounds.size.width / 2,self.bounds.size.height / 2 - 3)
        addSubview(dayLabel)
        chineseDayLabel.textAlignment = .Center
        chineseDayLabel.font = UIFont.systemFontOfSize(9)
        var point = dayLabel.center
        point.y += 15
        chineseDayLabel.center = point
        addSubview(chineseDayLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
}


public struct ConstValue {
    static let DeviceWith:CGFloat = UIScreen.mainScreen().bounds.size.width
    static var HorizonMargin:CGFloat = 5.0
    static var VerticalMargin:CGFloat = 5.0
   static let chineseMonths:[String] = ["正月", "二月", "三月", "四月", "五月", "六月", "七月", "八月","九月", "十月", "冬月", "腊月"]
    static let chineseDays:[String] = ["初一","初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十","十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十", "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"]
    static let Weekdays:[String] = ["日", "一", "二", "三", "四", "五", "六"]
}

enum JWCalendarMonth:Int{
    case JWCalendarMonthPrevious = 0
    case JWCalendarMonthCurrent = 1
    case JWCalendarMonthNext = 2
}


class JWCalendarItem: UIView,UICollectionViewDataSource,UICollectionViewDelegate {

    var delegate:JWCalendarItemDelegate?
    var collectionView:UICollectionView?
    
    var date:NSDate? {
        willSet{
//            self.date = newValue
//            print("--->\(newValue)")
               self.collectionView?.reloadData()
        }
        didSet {
//            print("-****>\(oldValue)")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.initialize()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
//        self.initialize()
    }
    convenience init() {
        self.init(frame: CGRectZero)
        self.initialize()
        self.backgroundColor = UIColor.clearColor()
        self.frame = CGRectMake(0, 0, ConstValue.DeviceWith, self.collectionView!.frame.size.height + (ConstValue.VerticalMargin) * 2)
    }
    func setUpCollectionView(){
        
    }
    func initialize() {
        NSLog("common init")
        
        let itemWidth = (ConstValue.DeviceWith - ConstValue.HorizonMargin * 2)/7
        let itemHeight = itemWidth
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsetsZero
        
        flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight)
        
        flowLayout.minimumLineSpacing = 0
        
        flowLayout.minimumInteritemSpacing = 0
        
        let collectionViewFrame = CGRectMake(ConstValue.HorizonMargin, ConstValue.VerticalMargin, ConstValue.DeviceWith - ConstValue.HorizonMargin * 2, itemHeight * 6)
        self.collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: flowLayout)
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.backgroundColor = UIColor.clearColor()
        self.collectionView?.registerClass(JWCalendarCell.self, forCellWithReuseIdentifier: "CalendarCell")
        self.addSubview(self.collectionView!)
    }

    func nextMonthDate()->NSDate {
        let components = NSDateComponents()
        components.month = 1
        let nextMonthDate = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: self.date!, options: .WrapComponents)
        return nextMonthDate!
    }
    
    func previousMonthDate() -> NSDate{
        let components = NSDateComponents()
        components.month = -1
        let previousMonthDate = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: self.date!, options: .WrapComponents)
        return previousMonthDate!
    }
    
    func weekdayOfFirstDayInDate() -> NSInteger{
        let calenar = NSCalendar.currentCalendar()
        calenar.firstWeekday = 1
        let components = calenar.components([.Year,.Month,.Day], fromDate:self.date!)
        components.day = 1
        let firstDate = calenar.dateFromComponents(components)
        let firstComponents = calenar.components([.Weekday], fromDate: firstDate!)
        return firstComponents.weekday - 1;
    }
   
    
    func totalDaysMonthOfDate(time:NSDate) -> NSInteger {
        let range = NSCalendar.currentCalendar().rangeOfUnit(.Day, inUnit: .Month, forDate: time)
        return range.length
    }
    
    func dateofMonth(calendarMnth:JWCalendarMonth,day:NSInteger) -> NSDate {
        let calenar = NSCalendar.currentCalendar()
        var time:NSDate
        switch calendarMnth {
        case .JWCalendarMonthPrevious:
            time = previousMonthDate()
                break
        case .JWCalendarMonthCurrent:
            time = self.date!
            break
        case .JWCalendarMonthNext:
            time = nextMonthDate()
            break
        }
        let components = calenar.components([.Year,.Month,.Day], fromDate:time)
        components.day = day;
        let dateOfDay = calenar.dateFromComponents(components)
        return dateOfDay!
    }
    
    func chineseCalendarOfDate(time:NSDate) -> NSString {
        var day:String
        let chineseCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierChinese)
        let components = chineseCalendar?.components([.Year,.Month,.Day], fromDate: time)
        
        if components?.day == 1 {
            day = ConstValue.chineseMonths[(components?.month)! - 1]
        }else
        {
            day = ConstValue.chineseDays[(components?.day)! - 1]
        }
        return day
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("CalendarCell", forIndexPath: indexPath)  as! JWCalendarCell
        cell.backgroundColor = UIColor.clearColor()
        cell.dayLabel.textColor = UIColor.blackColor()
        cell.chineseDayLabel.textColor = UIColor.grayColor()
        let firstWeekDay = weekdayOfFirstDayInDate()
        let totalDayOfMonth = totalDaysMonthOfDate(self.date!)
        let totalDaysOfLastMoth = totalDaysMonthOfDate(previousMonthDate())
        
        if (indexPath.row < firstWeekDay){
            let day = totalDaysOfLastMoth - firstWeekDay + indexPath.row + 1
            cell.dayLabel.text = "\(day)"
            cell.dayLabel.textColor = UIColor.grayColor()
            cell.chineseDayLabel.text = chineseCalendarOfDate(dateofMonth(.JWCalendarMonthPrevious, day: day))
             as String
        }else if(indexPath.row >= totalDayOfMonth + firstWeekDay) {
            let day = indexPath.row - totalDayOfMonth - firstWeekDay + 1
            cell.dayLabel.text = "\(day)"
            cell.dayLabel.textColor = UIColor.grayColor()
            cell.chineseDayLabel.text = chineseCalendarOfDate(dateofMonth(.JWCalendarMonthNext, day: day)) as String
        }else
        {
            let day = indexPath.row - firstWeekDay + 1
            cell.dayLabel.text = "\(day)"
            if(day == NSCalendar.currentCalendar().component(.Day, fromDate: self.date!)){
                cell.backgroundColor = UIColor.redColor()
                cell.layer.cornerRadius = cell.frame.size.height / 2;
                cell.dayLabel.textColor = UIColor.whiteColor()
                cell.chineseDayLabel.textColor = UIColor.whiteColor()
            }
            if ((NSCalendar.currentCalendar().isDate(NSDate(), equalToDate: self.date!, toUnitGranularity: .Month))
                && !(NSCalendar.currentCalendar().isDateInToday(self.date!))){
                    
                    if (day == NSCalendar.currentCalendar().component(NSCalendarUnit.Day, fromDate: NSDate())){
                        cell.dayLabel.textColor = UIColor.redColor()
                       
                    }
            }
            cell.chineseDayLabel.text = chineseCalendarOfDate(dateofMonth(.JWCalendarMonthCurrent, day: day)) as String
            
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let components = NSCalendar.currentCalendar().components([.Year,.Month,.Day], fromDate: self.date!)
        let firstWeekday = weekdayOfFirstDayInDate()
        components.day = indexPath.row - firstWeekday + 1
        let selectedDate = NSCalendar.currentCalendar().dateFromComponents(components)!
        print(".....")
        if (delegate != nil) {
            delegate?.calendarItem(self, date: selectedDate)
        }
    }
    
}

