//
//  PostedJobsTableViewController.swift
//  uService
//
//  Created by Kendrick Choate on 12/4/16.
//  Copyright © 2016 Kendrick Choate. All rights reserved.
//

import UIKit

class PostedJobsTableViewController: UITableViewController {
    var loggedInUser: LoggedInUser? = nil
    var listOfJobs: [Job] = []
    var selectedCell: Int = 0
    let amazonKey = "https://0944tu0fdb.execute-api.us-west-2.amazonaws.com/prod/jobs"
    let colorDarkGreen = UIColor(colorLiteralRed: 62/255, green: 137/255, blue: 20/255, alpha: 1)
    override func viewDidLoad() {
        super.viewDidLoad()
        updateJobList()
    }
    
    func updateJobList() {
        //TODO: Uncomment next line once UIDs have been updated from base64 to email addresses
        //let requestURL: URL = URL(string: amazonKey + (loggedInUser?.uid)!)!\
        let requestURL: URL = URL(string: "\(amazonKey)")!
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
                dateFormatter.dateFormat = "MM/dd/yyyy"
                let numberFormatter = NumberFormatter()
                numberFormatter.locale = Locale(identifier: "en-US")
                numberFormatter.numberStyle = .currency
                DispatchQueue.main.async {
                    for job in parsedData {
                        let tempJob = job as! [String:Any]
                        let attributes = tempJob["attributes"] as! [String:Any]
                        let properties = attributes["properties"] as! [String:Any]
                        let tempJobJID = tempJob["jid"] as! String
                        let tempJobDate = attributes["date"] as! Double
                        let tempJobLong = attributes["longitude"] as! Double
                        let tempJobLat = attributes["latitude"] as! Double
                        let tempJobPay = attributes["pay"] as! String
                        var tempJobTitle = properties["title"] as? String
                        if tempJobTitle == nil {
                            tempJobTitle = ""
                        }
                        var tempJobDescription = properties["description"] as? String
                        if tempJobDescription == nil {
                            tempJobDescription = ""
                        }
                        var tempJobDueDate = properties["dueDate"] as? String
                        if tempJobDueDate == nil {
                            tempJobDueDate = "12/25/2016"
                        }
                        let tempJobDueDateFromApexTime = dateFormatter.date(from: tempJobDueDate!)?.timeIntervalSince1970
                        let jobListing = Job(JID: tempJobJID, Title: tempJobTitle!, Longitude: tempJobLong, Latitude: tempJobLat, Pay: Float(tempJobPay)!, Description: tempJobDescription!, DueDate: tempJobDueDateFromApexTime!, PostDate: tempJobDate)
                        self.listOfJobs.append(jobListing)
                    }
                    self.tableView.reloadData()
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfJobs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        cell.textLabel?.text = "\(listOfJobs[indexPath.row].title) - $\(listOfJobs[indexPath.row].pay)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedCell = indexPath.row
        return indexPath
    }
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "viewPostedJob") {
            let destinationVC = segue.destination as! JobApplicationViewController
            destinationVC.selectedJob = listOfJobs[selectedCell]
            destinationVC.title = listOfJobs[selectedCell].title
            
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
        }
    }
}
