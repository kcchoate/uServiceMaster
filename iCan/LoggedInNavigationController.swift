//
//  LoggedInNavigationController.swift
//  uService
//
//  Created by Kendrick Choate on 12/4/16.
//  Copyright © 2016 Kendrick Choate. All rights reserved.
//

import UIKit

class LoggedInNavigationController: UINavigationController {
    var loggedInUser: LoggedInUser? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
