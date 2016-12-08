//
//  GraphViewCell.swift
//  ExpenseTracker
//
//  Created by Narender Kumar on 10/12/16.
//  Copyright © 2016 Narender Kumar. All rights reserved.
//

import UIKit
import RealmSwift

class GraphViewCell: UITableViewCell, LineChartDelegate {
    
    var label = UILabel()
    var lineChart: LineChart!
    var startDate = ""
    var endDate = ""
    
    var amountArray = [CGFloat]()
    var dateArray = [String]()
    
    @IBOutlet weak var gView: UIView!
    @IBOutlet weak var segmentView: UISegmentedControl!
    @IBOutlet weak var startDateLbl: UILabel!
    @IBOutlet weak var endDateLbl: UILabel!
    
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
        }
        else if sender.selectedSegmentIndex == 1 {
            print("selectedSegmentIndex = 15Days")
        }
        else if sender.selectedSegmentIndex == 2 {
            print("selectedSegmentIndex = month")
        }
        else if sender.selectedSegmentIndex == 3 {
            print("selectedSegmentIndex = Custom")
        }
    }
    
    func setGraph() {
        
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
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        
        let current = NSDate()
        let sevenDaysAgo = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -15,
                                                                         toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))
        print("sevenDaysAgo : \(sevenDaysAgo)")
        let realm = try! Realm()
        let messages = realm.objects(AccountInfo).filter("transactionDate > %@ AND transactionDate <= %@", sevenDaysAgo!, current)
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

        startDateLbl.text = dateFormatter.stringFromDate(current)
        endDateLbl.text = dateFormatter.stringFromDate(sevenDaysAgo!)
        
        var views: [String: AnyObject] = [:]
        
        label.text = "..."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.Center
        gView.addSubview(label)
        views["label"] = label
        gView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label]-|", options: [], metrics: nil, views: views))
        gView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-00-[label]", options: [], metrics: nil, views: views))
        
        // simple arrays
        let data: [CGFloat] = [3, 4, -2, 11, 13, 15] // Yaxis
        let data2: [CGFloat] = amountArray//[100, 300, 500, 1300, 1700, 2000, 2900, 900, 1200, 2800, 3500, 1000] //ValueData
        
        // simple line with custom x axis labels
       // let xLabels: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let xLabels: [String] = dateArray//[" "," "]
        
        for tempView in gView.subviews {
            if tempView.isKindOfClass(LineChart) {
                tempView.removeFromSuperview()
                break
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
        
    }
    
    func didSelectDataPoint(x: CGFloat, yValues: Array<CGFloat>) {
        label.text = "Date: \(dateArray[Int(x)])   Rs: \(yValues)"
    }
    
    func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        if let chart = lineChart {
            chart.setNeedsDisplay()
        }
    }
}










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




