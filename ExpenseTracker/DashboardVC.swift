//
//  DashboardVC.swift
//  ExpenseTracker
//
//  Created by Narender Kumar on 10/7/16.
//  Copyright © 2016 Narender Kumar. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let nib = UINib(nibName:"GraphViewCell", bundle: nil)
        tblView.registerNib(nib, forCellReuseIdentifier: "GraphViewCell")
        tblView.registerNib(UINib(nibName: "DetailsCell", bundle: nil), forCellReuseIdentifier: "DetailsCell")
        tblView.registerNib(UINib(nibName: "SettingCell", bundle: nil), forCellReuseIdentifier: "SettingCell")
        tblView.estimatedRowHeight = 590
        tblView.rowHeight = UITableViewAutomaticDimension

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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(indexPath.row == 0) {
            let cell:GraphViewCell = (tblView.dequeueReusableCellWithIdentifier("GraphViewCell", forIndexPath: indexPath) as? GraphViewCell)!
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


