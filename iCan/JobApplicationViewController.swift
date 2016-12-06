//
//  JobApplicationViewController.swift
//  uService
//
//  Created by Tyler Allen on 11/23/16.
//  Copyright © 2016 Kendrick Choate. All rights reserved.
//

import UIKit

class JobApplicationViewController: UIViewController {
    var selectedJob = Job()
    
    @IBOutlet weak var dueByTextView: UITextView!
    @IBOutlet weak var paymentTextView: UITextView!
    @IBOutlet weak var jobDateTextView: UITextView!
    @IBOutlet weak var detailsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        let currencyFormatter = NumberFormatter()
        currencyFormatter.locale = Locale(identifier: "en-US")
        currencyFormatter.numberStyle = .currency
        dueByTextView.text! = dateFormatter.string(from: Date(timeIntervalSince1970: selectedJob.dueDate))
        paymentTextView.text! = currencyFormatter.string(from: NSNumber(value: selectedJob.pay))!
        jobDateTextView.text! = dateFormatter.string(from: Date(timeIntervalSince1970: selectedJob.date))
        detailsTextView.text! = selectedJob.description
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func applyForJobPressed() {
        //TODO: - Send application to job to server 
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
