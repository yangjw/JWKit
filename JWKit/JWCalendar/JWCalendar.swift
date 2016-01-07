//
//  JWCalendar.swift
//  JWKitLearn
//
//  Created by njdby on 16/1/7.
//  Copyright © 2016年 njdby. All rights reserved.
//

import Foundation
import UIKit

class JWCalendar: UIView,UIScrollViewDelegate,JWCalendarItemDelegate {
    var titleButton:UIButton?
    var scrollView:UIScrollView?
    var leftCalendarItem:JWCalendarItem?
    var centerCalendarItem:JWCalendarItem?
    var rightCalendarItem:JWCalendarItem?
    var backgroundView:UIView?
    var datePickerView:UIView?
    var datePicker:UIDatePicker?
    var date:NSDate
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(date:NSDate) {
        self.date = date
        super.init(frame:CGRectZero)
        self.setUpTitleBar()
        self.setUpWeekHeader()
        self.setupCalendarItems()
        self.setCurrentDate(self.date)
        self.setupScrollView()
        self.frame = CGRectMake(0, 0, ConstValue.DeviceWith, CGRectGetMaxY(self.scrollView!.frame))
        self.initView()
    }
//    初始化
    func initView() -> Void {
        self.backgroundView = UIView(frame: self.bounds)
        self.backgroundView?.backgroundColor = UIColor.blackColor()
        self.backgroundView?.alpha = 0;
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideDatePickerView")
        self.backgroundView?.addGestureRecognizer(tap)
        self.addSubview(self.backgroundView!)
        
        self.datePickerView = UIView(frame:CGRectMake(0,0,self.frame.size.width,0))
        self.datePickerView?.backgroundColor = UIColor.whiteColor()
        self.datePickerView?.clipsToBounds = true
        
        let cancelButton = UIButton(type: .Custom)
        cancelButton.frame = CGRectMake(20, 10, 32, 20)
        cancelButton.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        cancelButton.setTitle("取消", forState: .Normal)
        cancelButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        cancelButton.addTarget(self, action: "cancelSelectCurrentDate", forControlEvents: .TouchUpInside)
        datePickerView?.addSubview(cancelButton)
        
        let okButton = UIButton(type:.Custom)
        okButton.frame = CGRectMake(self.frame.width - 52, 10, 32, 20)
        okButton.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        okButton.setTitle("确定", forState: .Normal)
        okButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        okButton.addTarget(self, action: "selectCurrentDate", forControlEvents: .TouchUpInside)
        datePickerView?.addSubview(okButton)
        self.addSubview(self.datePickerView!)
        
        self.datePicker = UIDatePicker()
        self.datePicker?.datePickerMode = .Date
        self.datePicker?.locale = NSLocale(localeIdentifier: "Chinese")
        var frame = self.datePicker?.frame
        frame?.origin = CGPointMake(0, 32)
        self.datePicker?.frame = frame!
        self.datePickerView?.addSubview(self.datePicker!)
    }
    
    func stringFromDate(date:NSDate) -> NSString {
        let dateForMatter = NSDateFormatter()
        dateForMatter.dateFormat = "MM-yyyy"
        return dateForMatter.stringFromDate(date)
    }
//    初始化导航
    func setUpTitleBar(){
        let titleView: UIView = UIView(frame: CGRectMake(0, 0,ConstValue.DeviceWith, 44))
        titleView.backgroundColor = UIColor.redColor()
        self.addSubview(titleView)
        let leftButton: UIButton = UIButton(frame: CGRectMake(5, 10, 32, 24))
        leftButton.setImage(UIImage(named: "icon_previous"), forState: .Normal)
        leftButton.addTarget(self, action: "setPreviousMonthDate", forControlEvents: .TouchUpInside)
        titleView.addSubview(leftButton)
        let rightButton: UIButton = UIButton(frame: CGRectMake(titleView.frame.size.width-37, 10, 32, 24))
        rightButton.setImage(UIImage(named:"icon_next"), forState: .Normal)
        rightButton.addTarget(self, action: "setNextMonthDate", forControlEvents: .TouchUpInside)
        titleView.addSubview(rightButton)
        let titleButton: UIButton = UIButton(frame: CGRectMake(0, 0, 100, 44))
        titleButton.titleLabel?.textColor = UIColor.whiteColor()
        titleButton.titleLabel?.font = UIFont.boldSystemFontOfSize(20)
        titleButton.center = titleView.center
        titleButton.addTarget(self, action: "showDatePicker", forControlEvents: .TouchUpInside)
        titleView.addSubview(titleButton)
        self.titleButton = titleButton
    }
//    星期几展示控件
    func setUpWeekHeader() -> Void {
        let count: Int = ConstValue.Weekdays.count
        var offsetX: CGFloat = 5
        for i in 0..<count {
            let weekdayLabel: UILabel = UILabel(frame: CGRectMake(offsetX, 50, (ConstValue.DeviceWith - 10.0) /  CGFloat(count), 20))
            weekdayLabel.textAlignment = .Center
            weekdayLabel.text = ConstValue.Weekdays[i]
            if i == 0 || i == count-1 {
                weekdayLabel.textColor = UIColor.redColor()
            } else {
                weekdayLabel.textColor = UIColor.grayColor()
                
            }
            self.addSubview(weekdayLabel)
            offsetX += weekdayLabel.frame.size.width
        }
        let lineView: UIView = UIView(frame: CGRectMake(15, 74, ConstValue.DeviceWith - 30, 1))
        lineView.backgroundColor = UIColor.lightGrayColor()
        self.addSubview(lineView)
    }
//    设置scrollView
    func setupScrollView() ->Void {
        self.scrollView!.delegate = self
        self.scrollView!.pagingEnabled = true
        self.scrollView!.showsHorizontalScrollIndicator = false
        self.scrollView!.showsVerticalScrollIndicator = false
        self.scrollView!.frame = CGRectMake(0, 75, ConstValue.DeviceWith, self.centerCalendarItem!.frame.size.height)
        self.scrollView!.contentSize = CGSizeMake(3 * self.scrollView!.frame.size.width, self.scrollView!.frame.size.height)
        self.scrollView!.contentOffset = CGPointMake(self.scrollView!.frame.size.width, 0)
        self.addSubview(self.scrollView!)

        
    }
//    初始化日历控件
    func setupCalendarItems() -> Void {
        self.scrollView = UIScrollView()
        self.leftCalendarItem = JWCalendarItem()
        self.scrollView!.addSubview(self.leftCalendarItem!)
        var itemFrame: CGRect = self.leftCalendarItem!.frame
        itemFrame.origin.x = ConstValue.DeviceWith
        self.centerCalendarItem = JWCalendarItem()
        self.centerCalendarItem!.frame = itemFrame
        self.centerCalendarItem!.delegate = self
        self.scrollView!.addSubview(self.centerCalendarItem!)
        itemFrame.origin.x = ConstValue.DeviceWith * 2
        self.rightCalendarItem = JWCalendarItem()
        self.rightCalendarItem!.frame = itemFrame
        self.scrollView!.addSubview(self.rightCalendarItem!)
    }
//    设置时间
    func setCurrentDate(date:NSDate) {
        self.centerCalendarItem!.date = date
        self.leftCalendarItem!.date = self.centerCalendarItem!.previousMonthDate()
        self.rightCalendarItem!.date = self.centerCalendarItem!.nextMonthDate()
        self.titleButton!.setTitle(self.stringFromDate(self.centerCalendarItem!.date!) as String, forState: .Normal)
    }
//    刷新日历控件
    func reloadCalendarItems() {
        let offset = self.scrollView?.contentOffset
        if (offset?.x > self.scrollView?.frame.size.width) {
            self.setNextMonthDate()
        }else {
            self.setPreviousMonthDate()
        }
    }
//    上一个月日历
    func setPreviousMonthDate() -> Void {
        self.setCurrentDate((self.centerCalendarItem?.previousMonthDate())!)
    }
//    下个月日历
    func setNextMonthDate() ->Void {
        self.setCurrentDate((self.centerCalendarItem?.nextMonthDate())!)

    }
//    弹出pickView
    func showDatePicker() ->Void {
        UIView.animateWithDuration(0.25) { () -> Void in
            self.backgroundView?.alpha = 0.4
            self.datePickerView?.frame = CGRectMake(0,44,self.frame.size.width, 250)
        }
    }
//    隐藏pickView
    func hideDatePickerView() -> Void {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.backgroundView?.alpha = 0
            self.datePickerView?.frame = CGRectMake(0,44,self.frame.size.width, 0)
            }) { (Bool) -> Void in
//               self.backgroundView?.removeFromSuperview()
//               self.datePickerView?.removeFromSuperview()
        }
    }
//   关闭pickView
    func cancelSelectCurrentDate() -> Void {
        self.hideDatePickerView()
    }
//    选择日历
    func selectCurrentDate() -> Void {
        self.setCurrentDate((self.datePicker?.date)!)
        self.hideDatePickerView()
    }
//    滚动
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.reloadCalendarItems()
        self.scrollView?.contentOffset = CGPointMake(self.scrollView!.frame.size.width, 0)
    }
//    回调使用
    func calendarItem(item: JWCalendarItem, date: NSDate) {
        self.date = date
        self.setCurrentDate(self.date)
    }
}
