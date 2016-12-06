//
//  ApplicantsViewController.swift
//  uService
//
//  Created by Tyler Allen on 12/5/16.
//  Copyright © 2016 Kendrick Choate. All rights reserved.
//

import UIKit

class ApplicantsViewController: UIViewController {
    var selectedJob: Job? = nil
    
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var datePostedLabel: UILabel!

    @IBOutlet weak var applicantsTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        jobTitleLabel.text! = (selectedJob?.title)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        datePostedLabel.text! = dateFormatter.string(from: Date(timeIntervalSince1970: selectedJob!.date))
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
