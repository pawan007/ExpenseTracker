//
//  PriceCell.swift
//  ExpenseTracker
//
//  Created by Narender Kumar on 10/9/16.
//  Copyright © 2016 Narender Kumar. All rights reserved.
//

import Foundation
import UIKit

class PriceCell : UITableViewCell {
    var idx:Int = 0
    var titleStr:String = ""
    var amountStr:String = ""
    
    @IBOutlet weak var titelLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func cell() ->PriceCell {
        let cell:PriceCell = NSBundle.mainBundle().loadNibNamed("PriceCell", owner: self, options: nil)![0] as! PriceCell
        cell.accessoryType = .None
        cell.selectionStyle = .None
        return cell
    }
    
    func setData(index:Int, title:String, amount:String) {
        idx = index
        titelLbl.text = title
        amountLbl.text = amount
    }
}
