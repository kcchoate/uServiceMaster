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
    let amazonKey = "https://0944tu0fdb.execute-api.us-west-2.amazonaws.com/prod/jobs/"
    let amazonKeyForResume = "https://0944tu0fdb.execute-api.us-west-2.amazonaws.com/prod/users/"
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextView.text = selectedApplicant?.id
        
        let requestURL: URL = URL(string: amazonKeyForResume + (selectedApplicant?.id)!)!
        let urlRequest: URLRequest = URLRequest(url: requestURL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            //do stuff with response, data, and error here
            guard error == nil else {
                print ("error calling GET")
                return
            }
            guard let responseData = data else {
                print ("Error: did not receive data")
                return
            }
            do {
                var tempResume: String? = "User has no resume."
                let data = try JSONSerialization.jsonObject(with: responseData, options: []) as! [String:Any]
                let parsedData = data["data"] as! NSArray
                DispatchQueue.main.async {
                    for applicant in parsedData {
                        let tempApplicant = applicant as! [String:Any]
                        let attributes = tempApplicant["attributes"] as! [String:Any]
                        let properties = attributes["properties"] as! [String:Any]
                        tempResume = properties["resume"] as? String
                        if tempResume == nil {
                            tempResume = "User has no resume."
                        }
                    }
                    self.resumeTextView.text = tempResume
                }
                
            }
            catch {
                print ("Error trying to convert data to json")
                return
            }
            
        })
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func acceptPressed() {
        let newJob = [
            
            "data": [
                "type": "jobs",
                "jid": (self.selectedJob?.jid)!,
                "attributes": [
                    "assignedTo": (selectedApplicant?.id)!
                ]
            ]
        ] as [String: Any]
        let jsonData = try! JSONSerialization.data(withJSONObject: newJob, options: [.prettyPrinted])
        let requestURL: URL = URL(string: amazonKey + (self.selectedJob?.jid)!)!
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PATCH"
        request.httpBody = jsonData
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                OperationQueue.main.addOperation {
                    self.presentErrorNotification(errorTitle: "Unable to accept applicant.", errorMessage: (error?.localizedDescription)!)
                }
            } else {
                do {
                    guard let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] else { return }
                    
                    guard let errors = json?["errors"] as? [[String: Any]] else { return }
                    if errors.count > 0 {
                        OperationQueue.main.addOperation {
                            self.presentErrorNotification(errorTitle: "Unable to accept applicant", errorMessage: "Applicant accept failed due to a network error.")
                        }
                        return
                    } else {
                        
                    }
                }
            }
        })
        task.resume()
        OperationQueue.main.addOperation {
            self.presentErrorNotification(errorTitle: "Applicant accepted", errorMessage: "You have sucessfully accepted the selected applicant.")
        }

    }

    //a utility function for presenting an error notification to the user
    func presentErrorNotification(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

}
