//
//  ParserEngine.swift
//  ExpensesTracker
//
//  Created by Gurkaran Singh on 24/08/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation

final class ParserEngine {
    typealias Fields = (account: String, expense: String, info: String, date: String)
    
    /// Returns a collection of predefined fields' extracted values
    func fieldsByExtractingFrom(string: String) -> Fields {
        // 2.
        var (account, expense, info, date) = ("", "", "", "")
        
        // 3.
        let scanner = NSScanner(string: string)
        scanner.charactersToBeSkipped = NSCharacterSet(charactersInString: " :\n")
        
        // 4.
        while !scanner.atEnd {                    // A
            let field = scanner.scanUpTo(":") ?? "" // B
            let info = scanner.scanUpTo("\n") ?? "" // C
            
            // D
            //            switch field {
            //            case "From": (email, sender) = fromInfoByExtractingFrom(info) // E
            //            case "Subject": subject = info
            //            case "Date": date = info
            //            case "Organization": organization = info
            //            case "Lines": lines = Int(info) ?? 0
            //            default: break
            //            }
        }
        
        return (account, expense, info, date)
    }
    
    
}