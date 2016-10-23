//
//  ExpenseCategory.swift
//  ExpensesTracker
//
//  Created by Gurkaran Singh on 23/08/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class ExpenseCategory: NSObject {
    
    enum expenseType: String {
        case Bills
        case EMI
        case Entertainment
        case Food
        case Fuel
        case Groceries
        case Health
        case Investment
        case Other
        case Shopping
        case Transfer
        case Travel
    }
    
    var expense : String = ""
    var expenseDate : NSDate = NSDate()
    var accountNumber : String = ""
    var expenseInfo : String = ""
    var availableBalance : String = ""
}
