//
//  GraphViewCell.swift
//  ExpenseTracker
//
//  Created by Narender Kumar on 10/12/16.
//  Copyright © 2016 Narender Kumar. All rights reserved.
//

import UIKit
import RealmSwift
import THCalendarDatePicker
import KNSemiModalViewController_hons82

//protocol GraphViewCellDelegate{
//    func myVCDidFinish(controller:FooTwoViewController,text:String)
//}

class GraphViewCell: UITableViewCell, LineChartDelegate, THDatePickerDelegate {
    
    var label = UILabel()
    var lineChart: LineChart!
    var startDate:NSDate = NSDate()
    var endDate:NSDate = NSDate()
    var agoDays:Int = -15
    
    var amountArray = [CGFloat]()
    var dateArray = [String]()
    
    @IBOutlet weak var gView: UIView!
    @IBOutlet weak var segmentView: UISegmentedControl!
    @IBOutlet weak var startDateLbl: UILabel!
    @IBOutlet weak var endDateLbl: UILabel!
    
    var myView:UIViewController = UIViewController()
    
    //----------------Date-------------//
    var curDate:NSDate = NSDate()
    var formatter:NSDateFormatter!
    var datePicker:THDatePickerViewController = {
        var dp = THDatePickerViewController.datePicker()
       // dp.delegate = self
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

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        // Reset the cell for new row's data
        self.lineChart.hidden = true
    }
    
    
    class func instanceFromNib() -> GraphViewCell {
        return UINib(nibName: "GraphViewCell", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! GraphViewCell
    }
    
    
    class func cell() ->GraphViewCell {
        let cell:GraphViewCell = NSBundle.mainBundle().loadNibNamed("GraphViewCell", owner: self, options: nil)![0] as! GraphViewCell
        cell.accessoryType = .None
        cell.selectionStyle = .None
        return cell
    }
    
    @IBAction func segmentAction(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            print("selectedSegmentIndex = 7Days")
            agoDays = -7
            startDate = NSDate()
            setGraph()
        }
        else if sender.selectedSegmentIndex == 1 {
            print("selectedSegmentIndex = 15Days")
            agoDays = -15
            startDate = NSDate()
            setGraph()
        }
        else if sender.selectedSegmentIndex == 2 {
            print("selectedSegmentIndex = month")
            agoDays = -30
            startDate = NSDate()
            setGraph()
        }
        else if sender.selectedSegmentIndex == 3 {
            print("selectedSegmentIndex = Custom")
            agoDays = 0
        }
        
        //sender.selectedSegmentIndex = UISegmentedControlNoSegment
    }
    
    func setGraph() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        
        endDate = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: agoDays,
                                                                         toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))!
        print("sevenDaysAgo : \(endDate)")
        let realm = try! Realm()
        let messages = realm.objects(AccountInfo).filter("transactionDate > %@ AND transactionDate <= %@", endDate, startDate)
        print("restult : \(messages)")
        
        if messages.count > 0 {
            if amountArray.count > 0 {
                amountArray.removeAll()
            }
            if dateArray.count > 0 {
                dateArray.removeAll()
            }
            let dateFormatter1 = NSDateFormatter()
            dateFormatter1.dateFormat = "dd/MMM"
            for dataArray in messages {
                amountArray.append(CGFloat(dataArray.amount))
                let dd = dataArray.transactionDate
                dateArray.append(dateFormatter1.stringFromDate(dd))
            }
        }

        startDateLbl.text = dateFormatter.stringFromDate(startDate)
        endDateLbl.text = dateFormatter.stringFromDate(endDate)
        
        var views: [String: AnyObject] = [:]
        
        label.text = "..."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.Center
        gView.addSubview(label)
        views["label"] = label
        gView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label]-|", options: [], metrics: nil, views: views))
        gView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-00-[label]", options: [], metrics: nil, views: views))
        
        // simple arrays
        // let data: [CGFloat] = [3, 4, -2, 11, 13, 15] // Yaxis
        let data2: [CGFloat] = amountArray//[100, 300, 500, 1300, 1700, 2000, 2900, 900, 1200, 2800, 3500, 1000] //ValueData
        
        // simple line with custom x axis labels
        // let xLabels: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let xLabels: [String] = dateArray //[" "," "]
        
        for tempView in gView.subviews {
            if tempView.isKindOfClass(LineChart) {
                tempView.removeFromSuperview()
                break
            }
        }
        
        for temp in gView.subviews {
            if temp.isKindOfClass(LineChart) {
                temp.removeFromSuperview()
            }
        }
        
        lineChart = LineChart()
        lineChart.animation.enabled = true
        lineChart.area = true
        lineChart.x.labels.visible = true
        lineChart.x.grid.count = 7 //CGFloat(xLabels.count)
        lineChart.y.grid.count = 5
        lineChart.x.labels.values = xLabels
        lineChart.y.labels.visible = true
        lineChart.lineWidth = 1.5 //Data line
        // lineChart.addLine(data)
        lineChart.addLine(data2)
        
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.delegate = self
        gView.addSubview(lineChart)
        views["chart"] = lineChart
        gView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[chart]-|", options: [], metrics: nil, views: views))
        gView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[label]-[chart(==200)]", options: [], metrics: nil, views: views))
        
        
       // showDate()
        
    }
    
    func didSelectDataPoint(x: CGFloat, yValues: Array<CGFloat>) {
        label.text = "Date: \(dateArray[Int(x)])   Rs: \(yValues.first!)"
    }
    
    func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        if let chart = lineChart {
            chart.setNeedsDisplay()
        }
    }
    
    //MARK:- Date Picker 
    
    func refreshTitle() {
        //  dateButton.setTitle((curDate != nil ? formatter.stringFromDate(curDate) : "No date selected"), forState: UIControlState.Normal)
       // print("current date \(curDate)")
    }
    
    func showDate() {
        
        curDate = NSDate()
        
        datePicker.date = curDate
        datePicker.setDateHasItemsCallback({(date:NSDate!) -> Bool in
            let tmp = (arc4random() % 30) + 1
            return tmp % 5 == 0
        })
        
        let appDelegate:AppDelegate =  UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController!.presentSemiViewController(datePicker, withOptions:
            [KNSemiModalOptionKeys.pushParentBack.takeRetainedValue():false,
                KNSemiModalOptionKeys.parentAlpha.takeRetainedValue():1.0,
                KNSemiModalOptionKeys.animationDuration.takeRetainedValue():0.3])
        
    }
    
    // MARK: THDatePickerDelegate
    func datePickerDonePressed(datePicker: THDatePickerViewController!) {
       // curDate = datePicker.date
        refreshTitle()
        let appDelegate:AppDelegate =  UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController!.dismissSemiModalView()
    }
    
    func datePickerCancelPressed(datePicker: THDatePickerViewController!) {
       // dismissSemiModalView()
        let appDelegate:AppDelegate =  UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController!.dismissSemiModalView()
    }
    
    func datePicker(datePicker: THDatePickerViewController!, selectedDate: NSDate!) {
       // let tmp = formatter.stringFromDate(selectedDate)
       // print("Date selected: \(tmp)")
    }
}






/*
 let current = NSDate()
 let sevenDaysAgo = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -30,
 toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))
 print("sevenDaysAgo : \(sevenDaysAgo)")
 let realm = try! Realm()
 let messages = realm.objects(AccountInfo).filter("transactionDate > %@ AND transactionDate <= %@", sevenDaysAgo!, current)
 print("restult : \(messages)")
 */


//let realm = try! Realm()
//let objs = realm.objects(AccountInfo).toArray()


//let realm = try! Realm()
//let objects = realm.objects(AccountInfo).toArray(AccountInfo) as [AccountInfo]
//print("restult array : \(objects)")
//let objects1 = realm.objects(AccountInfo).get(0, limit: 10)
//let objects1 = realm.objects(AccountInfo).filter("ANY amount")
//print("restult array 10 : \(objects1)")





/*
 do {
 let realm = try Realm()
 let all = realm.objects(Model) // => doesn't fetch all Models from disk
 let pageSize = 10
 // iterate through page 2
 let pageNumber = 2
 for offset in (pageSize * pageNumber)..<(pageSize * (pageNumber + 1)) {
 let itemAtOffset = all[offset]
 // use itemAtOffset, e.g. to populate a table view cell
 }
 } catch error {
 // handle error
 }
*/




