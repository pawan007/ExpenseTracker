//
//  DashboardVC.swift
//  ExpenseTracker
//
//  Created by Narender Kumar on 10/7/16.
//  Copyright © 2016 Narender Kumar. All rights reserved.
//

import UIKit
import THCalendarDatePicker
import KNSemiModalViewController_hons82


class DashboardVC: UIViewController, UITableViewDataSource, UITableViewDelegate, THDatePickerDelegate {
    
    @IBOutlet weak var tblView: UITableView!
    //----------------Date-------------//
    var curDate:NSDate!
    var formatter:NSDateFormatter!
    lazy var datePicker:THDatePickerViewController = {
        var dp = THDatePickerViewController.datePicker()
        dp.delegate = self
        dp.setAllowClearDate(false)
        dp.setClearAsToday(true)
        dp.setAutoCloseOnSelectDate(false)
        dp.setAllowSelectionOfSelectedDate(true)
        dp.setDisableHistorySelection(false)
        dp.setDisableFutureSelection(true)
        //dp.autoCloseCancelDelay = 5.0
        dp.selectedBackgroundColor = UIColor(red: 125/255.0, green: 208/255.0, blue: 0/255.0, alpha: 1.0)
        dp.currentDateColor = UIColor(red: 242/255.0, green: 121/255.0, blue: 53/255.0, alpha: 1.0)
        dp.currentDateColorSelected = UIColor.yellowColor()
        return dp
    }()
    //-----------------------------------//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let nib = UINib(nibName:"GraphViewCell", bundle: nil)
        tblView.registerNib(nib, forCellReuseIdentifier: "GraphViewCell")
        tblView.registerNib(UINib(nibName: "DetailsCell", bundle: nil), forCellReuseIdentifier: "DetailsCell")
        tblView.registerNib(UINib(nibName: "SettingCell", bundle: nil), forCellReuseIdentifier: "SettingCell")
        tblView.estimatedRowHeight = 590
        tblView.rowHeight = UITableViewAutomaticDimension
        
        curDate = NSDate()
        formatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM/yyyy --- HH:mm"
        refreshTitle()
        
        // showDate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func checkAction(sender: AnyObject) {
        print("clcik meee...")
    }
    
    @IBAction func backAction(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func refreshTitle() {
      //  dateButton.setTitle((curDate != nil ? formatter.stringFromDate(curDate) : "No date selected"), forState: UIControlState.Normal)
        print("current date \(curDate)")
    }
    
    func showDate() {
            datePicker.date = curDate
            datePicker.setDateHasItemsCallback({(date:NSDate!) -> Bool in
                let tmp = (arc4random() % 30) + 1
                return tmp % 5 == 0
            })
        /*
            presentSemiViewController(datePicker, withOptions: [
                KNSemiModalOptionKeys.pushParentBack    : NSNumber(bool: false),
                KNSemiModalOptionKeys.animationDuration : NSNumber(float: 1.0),
                KNSemiModalOptionKeys.shadowOpacity     : NSNumber(float: 0.3)
                ])
         */
        
        self.presentSemiViewController(datePicker, withOptions:
            [KNSemiModalOptionKeys.pushParentBack.takeRetainedValue():false,
                KNSemiModalOptionKeys.parentAlpha.takeRetainedValue():1.0,
                KNSemiModalOptionKeys.animationDuration.takeRetainedValue():0.3])
    }
    
    // MARK: THDatePickerDelegate
    func datePickerDonePressed(datePicker: THDatePickerViewController!) {
        curDate = datePicker.date
        refreshTitle()
        dismissSemiModalView()
    }
    
    func datePickerCancelPressed(datePicker: THDatePickerViewController!) {
        dismissSemiModalView()
    }
    
    func datePicker(datePicker: THDatePickerViewController!, selectedDate: NSDate!) {
        let tmp = formatter.stringFromDate(selectedDate)
        print("Date selected: \(tmp)")
    }
    
    // MARK: TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(indexPath.row == 0) {
            let cell:GraphViewCell = (tblView.dequeueReusableCellWithIdentifier("GraphViewCell", forIndexPath: indexPath) as? GraphViewCell)!
            cell.myView = self
            cell.setGraph()
            return cell
        }
        else if(indexPath.row == 1) {
            let cell:DetailsCell = (tblView.dequeueReusableCellWithIdentifier("DetailsCell", forIndexPath: indexPath) as? DetailsCell)!
            cell.reloadTableData()
            return cell
        }
        else if(indexPath.row == 2) {
            let cell:SettingCell = (tblView.dequeueReusableCellWithIdentifier("SettingCell", forIndexPath: indexPath) as? SettingCell)!
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.row == 0) {
            return 590
        }
        else if(indexPath.row == 1) {
            return 590
        }
        else {
            return 590
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100;
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tempView:UIView = UIView.init(frame: CGRectMake(0, 0, 320, 100))
        tempView.backgroundColor = UIColor.purpleColor()
        return tempView;
    }
}


