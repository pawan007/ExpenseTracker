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
import RealmSwift

class AccountInfo: Object { //RLMObject {
    dynamic var id = 0
    dynamic var gMailId = ""
    dynamic var bankName = ""
    dynamic var accountNum = ""
    dynamic var debitCredit = ""
    dynamic var amount: Double = 0.0
    dynamic var transactionDate:NSDate = NSDate() 
    dynamic var transactionInfo = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    

    class func getModel() -> AccountInfo {
        let vCard = AccountInfo()
        vCard.id = vCard.IncrementaID()
        return vCard
    }
    
    //Incrementa ID
    func IncrementaID() -> Int {
        let realm = try! Realm()
        let RetNext: NSArray = Array(realm.objects(AccountInfo).sorted("id"))
        let last = RetNext.lastObject
        if RetNext.count > 0 {
            let valor = last?.valueForKey("id") as? Int
            return valor! + 1
        } else {
            return 1
        }
    }
}


extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        return array
    }
    
    
    func get <T:Object> (offset: Int, limit: Int ) -> Array<T>{
        //create variables
        var lim = 0 // how much to take
        var off = 0 // start from
        var l: Array<T> = Array<T>() // results list
        
        //check indexes
        if off<=offset && offset<self.count - 1 {
            off = offset
        }
        if limit > self.count {
            lim = self.count
        }else{
            lim = limit
        }
        
        //do slicing
        for i in off..<lim{
            let account = self[i] as! T
            l.append(account)
        }
        
        //results
        return l
    }
    
}


/*
 - (void)reloadData{
 self.baskets = [[Basket allObjects] arraySortedByProperty:@"dateCreated" ascending:YES];
 [self.tableView reloadData];
 }
 
 
 // Set the data for this cell:
 Basket *basket = [self.baskets objectAtIndex:indexPath.row];
 cell.textLabel.text = basket.name;
 cell.detailTextLabel.text = basket.shortDescription;
 
 */
