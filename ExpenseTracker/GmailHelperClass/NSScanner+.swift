//
//  NSScanner+.swift
//  ExpensesTracker
//
//  Created by Gurkaran Singh on 25/08/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
extension NSScanner {
    
    func scanUpToCharactersFrom(set: NSCharacterSet) -> String? {
        var result: NSString?                                                                  // 1.
        return scanUpToCharactersFromSet(set, intoString: &result) ? (result as? String) : nil // 2.
    }
    
    func scanUpTo(string: String) -> String? {
        var result: NSString?
        return scanUpToString(string, intoString: &result) ? (result as? String) : nil
    }
    
    func scanDouble() -> Double? {
        var double: Double = 0
        return scanDouble(&double) ? double : nil
    }
}