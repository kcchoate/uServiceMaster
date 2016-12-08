//
//  ApplicantsViewController.swift
//  uService
//
//  Created by Tyler Allen on 12/5/16.
//  Copyright © 2016 Kendrick Choate. All rights reserved.
//

class Applicant {
    var id: String
    var resume: String
    init(aid: String, applicantResume: String) {
        id = aid
        resume = applicantResume
    }
    init() {
        id = "hi"
        resume = "Awesome"
    }
}

import UIKit

class ApplicantsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var jobPayLabel: UILabel!
    @IBOutlet weak var jobDueByLabel: UILabel!
    @IBOutlet weak var datePostedLabel: UILabel!
    @IBOutlet weak var applicantTableView: UITableView!
    
    let amazonKey = "https://0944tu0fdb.execute-api.us-west-2.amazonaws.com/prod/applications?owner="
    
    var selectedJob: Job? = nil
    var loggedInUser: LoggedInUser? = nil
    var listOfApplicants: [Applicant] = []
    var selectedCell = 0
    let numberFormatter = NumberFormatter()
    let dateFormatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applicantTableView.delegate = self
        applicantTableView.dataSource = self
        
        //setting up the job labels
        dateFormatter.dateStyle = .medium
        numberFormatter.locale = Locale(identifier: "en-US")
        numberFormatter.numberStyle = .currency
        datePostedLabel.text! = "Date posted: \(dateFormatter.string(from: Date(timeIntervalSince1970: selectedJob!.date)))"
        jobDueByLabel.text! = "Due by: \(dateFormatter.string(from: Date(timeIntervalSince1970: selectedJob!.dueDate)))"
        jobPayLabel.text! = "Job cost: \(numberFormatter.string(from: NSNumber(value: selectedJob!.pay))!)"
        updateApplicantList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateApplicantList()
    }

    func updateApplicantList() {
        let requestURL: URL = URL(string: amazonKey + (loggedInUser?.uid)!)!
        let urlRequest: URLRequest = URLRequest(url: requestURL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            //do stuff with response, data, and error here
            guard error == nil else {
                print ("error calling GET")
                print (error)
                return
            }
            guard let responseData = data else {
                print ("Error: did not receive data")
                return
            }
            do {
                let data = try JSONSerialization.jsonObject(with: responseData, options: []) as! [String:Any]
                let parsedData = data["data"] as! NSArray
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .none
                dateFormatter.dateFormat = "MM/dd/yyyy"
                let numberFormatter = NumberFormatter()
                numberFormatter.locale = Locale(identifier: "en-US")
                numberFormatter.numberStyle = .currency
                DispatchQueue.main.async {
                    self.listOfApplicants = []
                    for application in parsedData {
                        let tempApplication = application as! [String:Any]
                        let attributes = tempApplication["attributes"] as! [String:Any]
                        let applicantID = attributes["applicant"] as! String
                        let jobID = attributes["jid"] as! String
                        if (jobID == self.selectedJob?.jid)
                        {
                            let applicant = Applicant(aid: applicantID, applicantResume: "test resume")
                            self.listOfApplicants.append(applicant)
                        }
                    }
                    self.applicantTableView.reloadData()
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

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listOfApplicants.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = "\(listOfApplicants[indexPath.row].id)"
        return cell
    }
    
    //saves the selected cell to know which data in the array of applicants to pass to next vc
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedCell = indexPath.row
        return indexPath
    }
    
    //deselects the cell after it is selected, else it stays selected after popping the next VC
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.applicantTableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        self.navigationItem.backBarButtonItem = backItem
        if (segue.identifier == "viewApplicantResume") {
            let nextVC = segue.destination as! ResumeViewController
            nextVC.selectedJob = self.selectedJob
            nextVC.selectedApplicant = listOfApplicants[selectedCell]
            nextVC.title = selectedJob?.title
        }
    }


}
