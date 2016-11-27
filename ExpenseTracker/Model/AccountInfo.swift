//
//  AccountInfo.swift
//  ExpenseTracker
//
//  Created by Narender Kumar on 10/27/16.
//  Copyright © 2016 Narender Kumar. All rights reserved.
//

import Foundation
import UIKit
import Realm

class AccountInfo: RLMObject {
    dynamic var bankName = ""
    dynamic var accountNum = ""
    dynamic var debitCredit = ""
    dynamic var amount: Double = 0.0
    dynamic var transactionDate = NSDate()
    dynamic var transactionInfo = ""
    dynamic var debited = ""
}
