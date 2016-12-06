//
//  SelectedApplicationViewController.swift
//  uService
//
//  Created by Kendrick Choate on 12/4/16.
//  Copyright © 2016 Kendrick Choate. All rights reserved.
//

import UIKit
//TODO: - Add button to remove application from server. Will need to connect to server to do so.
class SelectedApplicationViewController: UIViewController {
    var selectedJob = Job()
    @IBOutlet weak var paymentTextView: UITextView!
    @IBOutlet weak var postedTextView: UITextView!
    @IBOutlet weak var dueByTextView: UITextView!
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
        postedTextView.text! = dateFormatter.string(from: Date(timeIntervalSince1970: selectedJob.date))
        detailsTextView.text! = selectedJob.description
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
