//
//  GraphViewCell.swift
//  ExpenseTracker
//
//  Created by Narender Kumar on 10/12/16.
//  Copyright © 2016 Narender Kumar. All rights reserved.
//

import UIKit

class GraphViewCell: UITableViewCell, LineChartDelegate {
    
    var label = UILabel()
    var lineChart: LineChart!
    @IBOutlet weak var gView: UIView!
    
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
    
    func setGraph() {
        var views: [String: AnyObject] = [:]
        
        label.text = "..."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.Center
        gView.addSubview(label)
        views["label"] = label
        gView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label]-|", options: [], metrics: nil, views: views))
        gView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-00-[label]", options: [], metrics: nil, views: views))
        
        // simple arrays
        let data: [CGFloat] = [3, 4, -2, 11, 13, 15]
        let data2: [CGFloat] = [1, 3, 5, 13, 17, 20, 29, 0, 12, 28, 35, 10]
        
        // simple line with custom x axis labels
        let xLabels: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        
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
        label.text = "x: \(x)     y: \(yValues)"
    }
    
    func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        if let chart = lineChart {
            chart.setNeedsDisplay()
        }
    }
}
