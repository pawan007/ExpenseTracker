//
//  ViewController.swift
//  ExpenseTracker
//
//  Created by Narender Kumar on 10/7/16.
//  Copyright © 2016 Narender Kumar. All rights reserved.
//

import GoogleAPIClient
import GTMOAuth2
import SwiftSpinner
import RealmSwift

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var bgEffectView: UIVisualEffectView!
    
    @IBOutlet var bankBtn: [UIButton]!
    
    
    var emailMessages : NSMutableArray = []
    private let kTransactionSentence = "transaction of inr " //"subject: transaction alert"
    private let kKeychainItemName = "Gmail API"
    private let kClientID = "866202949798-09gknp24snotj0bh87b4jg6ii4chdjd0.apps.googleusercontent.com"
    
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    private let scopes = [kGTLAuthScopeGmailReadonly]
    
    private let service = GTLServiceGmail()
    let output = UITextView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        output.frame = view.bounds
        output.editable = false
        output.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        output.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        //view.addSubview(output); TODO: look into this
        
        if let auth = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychainForName(
            kKeychainItemName,
            clientID: kClientID,
            clientSecret: nil) {
            service.authorizer = auth
        }
        bgEffectView.layer.cornerRadius = 3.5
        bgEffectView.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     @IBAction func bankBtnAction(_ sender: UIButton) {
     for tempBtn in self.bankBtn as [UIButton] {
     tempBtn.selected = false
     }
     sender.selected = true;
     }
     */
    
    
    @IBAction func loginAction(sender: AnyObject) {
        /*
         let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
         let vc : DashboardVC = mainStoryboard.instantiateViewControllerWithIdentifier("DashboardVC") as! DashboardVC
         self.navigationController?.pushViewController(vc, animated: true)
         return
         */
        
        
        if let authorizer = service.authorizer,
            let canAuth = authorizer.canAuthorize where canAuth {
            SwiftSpinner.show("Connecting to your gmail account...")
            fetchLabels()
            
            // SwiftSpinner.hide()
            // let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            // let vc : DashboardVC = mainStoryboard.instantiateViewControllerWithIdentifier("DashboardVC") as! DashboardVC
            // self.navigationController?.pushViewController(vc, animated: true)
        } else {
            presentViewController(createAuthController(), animated: true, completion: nil)
        }
        
        
        
        // presentViewController(createAuthController(), animated: true, completion: nil)
    }
    
    // MARK: Custom Methods
    // Construct a query and get a list of upcoming labels from the gmail API
    func fetchLabels() {
        SwiftSpinner.show("Connecting to Gmail server...")
        output.text = "Getting messages..."
        let query = GTLQueryGmail.queryForUsersMessagesList()
        query.q = kTransactionSentence
        query.format = kGTLGmailFormatFull
        service.executeQuery(query,
                             delegate: self,
                             didFinishSelector: #selector(ViewController.displayResultWithTicket(_:finishedWithObject:error:))
        )
    }
    
    // Display the labels in the UITextView
    func displayResultWithTicket(ticket : GTLServiceTicket,
                                 finishedWithObject labelsResponse : GTLGmailListMessagesResponse,
                                                    error : NSError?) {
        if let error = error {
            showAlert("Error", message: error.localizedDescription)
            return
        }
        
        // HERE
        let array = labelsResponse.messages as NSArray
        let batchQuery = GTLBatchQuery ()
        for message in array as! [GTLGmailMessage] {
            
            let midentifier = message.identifier
            let query = GTLQueryGmail.queryForUsersMessagesGet()
            query.identifier = midentifier
            query.format = kGTLGmailFormatFull
            batchQuery.addQuery(query)
            
        }
        
        self.service.executeQuery(batchQuery,
                                  delegate: self,
                                  didFinishSelector: #selector(ViewController.displayResultWithTicketEachMessages(_:finishedWithObject:error:)))
    }
    
    
    func parseEmailMessages() {
        print("End all mail")
        print("messages are \(emailMessages)")
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : DashboardVC = mainStoryboard.instantiateViewControllerWithIdentifier("DashboardVC") as! DashboardVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func displayResultWithTicketEachMessages(ticket : GTLServiceTicket, finishedWithObject eachMessageResponse : GTLBatchResult, error : NSError?) {
        
        SwiftSpinner.hide()
        
        if error != nil {
            print("eroor happende")
            return
        } else {
            
            /*
             let msg: String = "You have used your Debit Card linked to Account XXXXXXXX5531 for a transaction of INR 600.00 Info.MPS*EVER GREEN on 23-08-2016 17:12:01. The available balance in your Account is Rs. 2,034.17."
             */
            var i = 0;
            let expenseMessages = eachMessageResponse.successes.allValues
            for message in expenseMessages as! [GTLGmailMessage] {
                
                var dataValue        = 0
                var amount: Double   = 0.00
                var date             = NSDate()
                var gMailId          = ""
                var accountNo        = ""
                var information      = ""
                var debited          = "credited"
                
                let parts = message.payload.body
                var decodedBody: NSString?
                if parts != nil {
                    // let body: AnyObject? = parts.valueForKey("body")
                    if parts!.valueForKey("data") != nil {
                        var base64DataString =  parts!.valueForKey("data") as! String
                        base64DataString = base64DataString.stringByReplacingOccurrencesOfString("_", withString: "/", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        base64DataString = base64DataString.stringByReplacingOccurrencesOfString("-", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        
                        let decodedData = NSData(base64EncodedString: base64DataString, options:NSDataBase64DecodingOptions(rawValue: 0))
                        decodedBody = NSString(data: decodedData!, encoding: NSUTF8StringEncoding)
                    }
                    
                }
                
                if let shortMessage : String = decodedBody as? String //message.payload.body.data //message.snippet  //msg//message.snippet
                {
                    let currencyPattern : String = "[Ii][Nn][Rr](\\s*.\\s*\\d*)"
                    let accountNumPattern : String = "\\b(Account)(XX)\\b"
                    let timeRegex : String = "(\\d{1,2}[-/.]\\d{1,2}[-/.]\\d{4}[-/. ]\\d\\d?:\\d\\d)"
                    //Account XXXXXXXX5531
                    let accountRegex : String = "[Aa][/][Cc][ ][0-9]{6} | [A][c][c][o][u][n][t][ ][X]{8}[0-9]{4}"
                    //Info: CASH-ATM/00009204.
                    //Info.MIN*PayTM on
                    //Info.MPS*EVER GREEN on
                    //([^ ]+) .*,
                    //[^\\s]+   -- Ax
                    let infoRegex : String = "[Ii][Nn][Ff][Oo][  -/.: ]([^[on]]+).*"
                    // let infoRegex : String = "[Ii][Nn][Ff][Oo][  -/.: ]([^[on]]+)* | [Ii][Nn][Ff][Oo][  -/.: ][^\\s]+"
                    
                    //debited
                    let debitedPattern : String = "[Dd][Ee][Bb][Ii][Tt][Ee][Dd]"
                    /*
                     Your a/c 027012 is debited INR 2000.00 on 25-10-2015 21:59:26 A/c Bal is INR 15866.53 Info: CASH-ATM/01076095. Get Axis Mobile: m.axisbank.com/cwdl
                     nYour a/c 027012 is debited INR 2.00 on 30-03-2016 22:47:55 Info: PUR/AMAZON INTERNET SERVIC/NEW DELHI/AMAZON INTERNET SERVIC
                     */
                    
                    i += 1
                    print (" \(i).")
                    print ("================ Start here====================")
                    print("Mail ID : \(message.identifier)")
                    gMailId = message.identifier
                    do {
                        let regex : NSRegularExpression = try NSRegularExpression.init(pattern: currencyPattern, options: NSRegularExpressionOptions.CaseInsensitive)
                        if let  match =  regex.firstMatchInString(shortMessage, options: NSMatchingOptions.ReportCompletion, range: NSMakeRange(0, shortMessage.characters.count))
                        {
                            // print("Amount : \((shortMessage as NSString).substringWithRange(match.range))")
                            let val:String = ((shortMessage as NSString).substringWithRange(match.range))
                            let replaced = val.stringByReplacingOccurrencesOfString("INR", withString: "")
                            let trimmedString = replaced.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                            print("Amount : \(trimmedString)")
                            dataValue += 1
                            amount = Double(trimmedString)!
                        }
                        
                    } catch let error as NSError {
                        print(error.description)
                    }
                    
                    do {
                        let regex : NSRegularExpression = try NSRegularExpression.init(pattern: accountNumPattern, options: NSRegularExpressionOptions.CaseInsensitive)
                        if let  match =  regex.firstMatchInString(shortMessage, options: NSMatchingOptions.ReportCompletion, range: NSMakeRange(0, shortMessage.characters.count)) {
                            print("A : \((shortMessage as NSString).substringWithRange(match.range))")
                        }
                        
                    } catch let error as NSError {
                        print(error.description)
                    }
                    
                    do {
                        let regex : NSRegularExpression = try NSRegularExpression.init(pattern: timeRegex, options: NSRegularExpressionOptions.CaseInsensitive)
                        if let  match =  regex.firstMatchInString(shortMessage, options: NSMatchingOptions.ReportCompletion, range: NSMakeRange(0, shortMessage.characters.count)) {
                            print("Date : \((shortMessage as NSString).substringWithRange(match.range))")
                            dataValue += 1
                            
                            let dateVal:String = ((shortMessage as NSString).substringWithRange(match.range))
                            let dateFormatter = NSDateFormatter()
                            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm" //25-10-2015 21:59 //yyyy-MM-dd'T'HH:mm:ss
                            date = dateFormatter.dateFromString(dateVal)!
                            print("DateChange : \(date)")
                        }
                        
                    } catch let error as NSError {
                        print(error.description)
                        print ("Date not found")
                    }
                    
                    do {
                        let regex : NSRegularExpression = try NSRegularExpression.init(pattern: accountRegex, options: NSRegularExpressionOptions.CaseInsensitive)
                        if let  match =  regex.firstMatchInString(shortMessage, options: NSMatchingOptions.ReportCompletion, range: NSMakeRange(0, shortMessage.characters.count)) {
                            print("Account : \((shortMessage as NSString).substringWithRange(match.range))")
                            dataValue += 1
                            accountNo = (shortMessage as NSString).substringWithRange(match.range)
                        } else {
                            print ("Account not found 1")
                        }
                        
                    } catch let error as NSError {
                        print(error.description)
                        print ("Account not found")
                    }
                    
                    do {
                        let regex : NSRegularExpression = try NSRegularExpression.init(pattern: infoRegex, options: NSRegularExpressionOptions.CaseInsensitive)
                        
                        if let  match =  regex.firstMatchInString(shortMessage, options: NSMatchingOptions.ReportCompletion, range: NSMakeRange(0, shortMessage.characters.count)) {
                            print("Information : \((shortMessage as NSString).substringWithRange(match.range))")
                            dataValue += 1
                            information = (shortMessage as NSString).substringWithRange(match.range)
                        } else {
                            print ("Information : Info not found")
                        }
                        
                    } catch let error as NSError {
                        print(error.description)
                    }
                    
                    do {
                        let regex : NSRegularExpression = try NSRegularExpression.init(pattern: debitedPattern, options: NSRegularExpressionOptions.CaseInsensitive)
                        if regex.firstMatchInString(shortMessage, options: NSMatchingOptions.ReportCompletion, range: NSMakeRange(0, shortMessage.characters.count)) != nil {
                            print("Debited : YES")
                            debited = "debited"
                        }
                        else {
                            print("Debited : NO")
                        }
                        dataValue += 1
                    } catch let error as NSError {
                        print(error.description)
                    }
                    
                    print ("================ End here====================")
                    print (" ")
                    print (" ")
                    
                    /*
                     ================ Start here====================
                     Amount : 30148
                     Account not found 1
                     Information : Info not found
                     Debited : NO
                     ================ End here====================
                     */
                    
                    //let scanner : NSScanner = NSScanner.init(string: shortMessage)
                    // let str = scanner.scanUpToCharactersFrom(NSCharacterSet.symbolCharacterSet())
                    //let str1 = scanner.scanUpTo(".")
                    emailMessages.addObject(shortMessage)
                    
                    //-------- Get min 2 value or data to insert in db -------------//
                    if(dataValue > 2) {
                        let realm = try! Realm()
                        //let accountInfo = AccountInfo()
                        let accountInfo = AccountInfo.getModel()
                        accountInfo.id = accountInfo.IncrementaID()
                        accountInfo.gMailId = gMailId
                        accountInfo.accountNum = accountNo
                        accountInfo.amount = amount
                        accountInfo.transactionDate = date
                        accountInfo.transactionInfo = information
                        accountInfo.debitCredit = debited
                        
                        let queryRecordID = realm.objects(AccountInfo).filter("gMailId == '\(gMailId)'")
                        if queryRecordID.count == 0 {
                            try! realm.write {
                                realm.add(accountInfo)
                            }
                        }
                    }
                    //-------------------------------------------------------------//
                }
            }
            self.parseEmailMessages()
        }
        
        let current = NSDate()
        let sevenDaysAgo = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -30,
                                                                         toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))
        print("sevenDaysAgo : \(sevenDaysAgo)")
        let realm = try! Realm()
        let messages = realm.objects(AccountInfo).filter("transactionDate > %@ AND transactionDate <= %@", sevenDaysAgo!, current)
        print("restult : \(messages)")
    }
    
    
    // Creates the auth controller for authorizing access to Gmail API
    private func createAuthController() -> GTMOAuth2ViewControllerTouch {
        let scopeString = scopes.joinWithSeparator(" ")
        return GTMOAuth2ViewControllerTouch(
            scope: scopeString,
            clientID: kClientID,
            clientSecret: nil,
            keychainItemName: kKeychainItemName,
            delegate: self,
            finishedSelector: #selector(ViewController.viewController(_:finishedWithAuth:error:))
        )
    }
    
    // Handle completion of the authorization process, and update the Gmail API
    // with the new credentials.
    func viewController(vc : UIViewController,
                        finishedWithAuth authResult : GTMOAuth2Authentication, error : NSError?) {
        
        if let error = error {
            service.authorizer = nil
            showAlert("Authentication Error", message: error.localizedDescription)
            return
        }
        service.authorizer = authResult
        dismissViewControllerAnimated(true, completion: nil)
        
        if let authorizer = service.authorizer,
            let canAuth = authorizer.canAuthorize where canAuth {
            fetchLabels()
            //  let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            //  let vc : DashboardVC = mainStoryboard.instantiateViewControllerWithIdentifier("DashboardVC") as! DashboardVC
            //  self.navigationController?.pushViewController(vc, animated: true)
            
        } else {}
    }
    
    // Helper for showing an alert
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.Default,
            handler: nil
        )
        alert.addAction(ok)
        presentViewController(alert, animated: true, completion: nil)
    }
}



import UIKit
extension String {
    
    func fromBase64() -> String? {
        guard let data = NSData(base64EncodedString: self, options: NSDataBase64DecodingOptions(rawValue: 0)) else {
            return nil
        }
        return String(data: data, encoding: NSUTF8StringEncoding)!
    }
    
    func toBase64() -> String? {
        guard let data = self.dataUsingEncoding(NSUTF8StringEncoding) else {
            return nil
        }
        return data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
    }
}

