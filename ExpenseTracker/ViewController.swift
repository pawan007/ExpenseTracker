//
//  ViewController.swift
//  ExpenseTracker
//
//  Created by Narender Kumar on 10/7/16.
//  Copyright © 2016 Narender Kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginAction(sender: AnyObject) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : DashboardVC = mainStoryboard.instantiateViewControllerWithIdentifier("DashboardVC") as! DashboardVC
        self.navigationController?.pushViewController(vc, animated: true)
    }


}

