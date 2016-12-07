//
//  ResumeViewController.swift
//  uService
//
//  Created by Kendrick Choate on 12/6/16.
//  Copyright © 2016 Kendrick Choate. All rights reserved.
//

//TODO: - Add info from cell selection into this page

import UIKit

class ResumeViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextView: UITextView!
    @IBOutlet weak var resumeTextView: UITextView!
    
    var selectedApplicant: Applicant? = nil
    var selectedJob: Job? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextView.text = selectedApplicant?.id
        resumeTextView.text = selectedApplicant?.resume
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func acceptPressed() {
        
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
