//
//  ModifyAccountViewController.swift
//  uService
//
//  Created by Tyler Allen on 12/5/16.
//  Copyright © 2016 Kendrick Choate. All rights reserved.
//

import UIKit

class ModifyAccountViewController: UIViewController {
    var loggedinUser: LoggedInUser? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backUserAccount" {
            let nextVC = segue.destination as! UserViewController
            nextVC.loggedInUser = self.loggedinUser
        }
    }

}
