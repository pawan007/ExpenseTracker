//
//  DetailsCell.swift
//  ExpenseTracker
//
//  Created by Narender Kumar on 10/21/16.
//  Copyright © 2016 Narender Kumar. All rights reserved.
//

import UIKit
import RealmSwift

class DetailsCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tblView: UITableView!
    var swiftBlogs = [AccountInfo]()
    var totalData:Int = 10
    var moreDataStr:String = "Load more.."
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func reloadTableData() {
        let realm = try! Realm()
        //let objects = realm.objects(AccountInfo).toArray(AccountInfo) as [AccountInfo]
        //print("restult array : \(objects)")
        let objects1 = realm.objects(AccountInfo).get((totalData - 10), limit: totalData)
        // swiftBlogs = objects1 as Array as! [AccountInfo]
        if objects1.count > 0 {
            for tempData in objects1 as! [AccountInfo] {
                swiftBlogs.append(tempData)
            }
            print("restult array 10 : \(objects1)")
            tblView.reloadData()
            totalData += 10
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let realm = try! Realm()
        let objects = realm.objects(AccountInfo).toArray(AccountInfo).count
        print("------ : \(objects)");
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (swiftBlogs.count + 1)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        if swiftBlogs.count > indexPath.row {
        let accountInfo:AccountInfo = swiftBlogs[indexPath.row]
            cell.selectionStyle = .None
            cell.textLabel?.text =  "\(indexPath.row). " // "\(accountInfo.transactionDate)"
            cell.detailTextLabel?.text = "\(accountInfo.transactionDate)" //accountInfo.transactionInfo
        return cell
        }
        else {
            cell.textLabel?.text = moreDataStr
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // tableView.deselectRowAtIndexPath(indexPath, animated: true)
        // let row = indexPath.row
        // print(swiftBlogs[row])
        
        if swiftBlogs.count == indexPath.row {
            let realm = try! Realm()
            let objects = realm.objects(AccountInfo).toArray(AccountInfo) as [AccountInfo]
            if swiftBlogs.count != objects.count {
                reloadTableData()
            } else {
                moreDataStr = "No more data..."
                let indexPath = NSIndexPath(forRow: swiftBlogs.count, inSection: 0)
                tblView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
            }
        }
    }
}
