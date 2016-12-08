//
//  MyJobsTableViewController.swift
//  uService
//
//  Created by Kendrick Choate on 12/4/16.
//  Copyright © 2016 Kendrick Choate. All rights reserved.
//

import UIKit
class Job {
    var owner: String
    var jid: String
    var title: String
    var longitude: Double
    var latitude: Double
    var pay: Float
    var description: String
    var dueDate: Double
    var date: Double
    init (Owner: String, JID: String, Title: String, Longitude: Double, Latitude: Double, Pay: Float, Description: String, DueDate: Double, PostDate: Double) {
        owner = Owner
        jid = JID
        title = Title
        longitude = Longitude
        latitude = Latitude
        pay = Pay
        description = Description
        dueDate = DueDate
        date = PostDate
    }
    init () {
        //default constructor used for testing
        owner = "Me"
        jid = "Test job"
        title = "Test job"
        longitude = 0
        latitude = 0
        pay = 0
        description = "Test job"
        dueDate = 0
        date = 0
    }
}
class MyJobsTableViewController: UITableViewController {
    var loggedInUser: LoggedInUser? = nil
    var selectedCell: Int = 0
    var listOfJobs: [Job] = []
    let colorDarkGreen = UIColor(colorLiteralRed: 62/255, green: 137/255, blue: 20/255, alpha: 1)
    let amazonKey = "https://0944tu0fdb.execute-api.us-west-2.amazonaws.com/prod/jobs?owner="
    let amazonKeyDelete = "https://0944tu0fdb.execute-api.us-west-2.amazonaws.com/prod/jobs/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorColor = colorDarkGreen
        self.editButtonItem.title = "Delete"
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        updateJobList()
    }

    func updateJobList() {
        let requestURL: URL = URL(string: amazonKey + (loggedInUser?.uid)!)!
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
                        let tempJobJID = tempJob["jid"] as! String
                        let properties = attributes["properties"] as! [String:Any]
                        let tempJobDate = attributes["date"] as! Double
                        let tempJobLong = attributes["longitude"] as! Double
                        let tempJobLat = attributes["latitude"] as! Double
                        let tempJobPay = attributes["pay"] as! String
                        let tempOwner = attributes["owner"] as! String
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
                        let jobListing = Job(Owner: tempOwner, JID: tempJobJID, Title: tempJobTitle!, Longitude: tempJobLong, Latitude: tempJobLat, Pay: Float(tempJobPay)!, Description: tempJobDescription!, DueDate: tempJobDueDateFromApexTime!, PostDate: tempJobDate)
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
    
    //sets the delete button to show done while editing is in progress and go back to delete when finished editing.
    override func setEditing (_ editing:Bool, animated:Bool)
    {
        super.setEditing(editing,animated:animated)
        if (self.isEditing) {
            self.editButtonItem.title = "Done"
        }
        else {
            self.editButtonItem.title = "Delete"
        }
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
        // #warning Incomplete implementation, return the number of rows
        return listOfJobs.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "en-US")
        let pay = listOfJobs[indexPath.row].pay
        let payString = numberFormatter.string(from: NSNumber(value: pay))!
        cell.textLabel?.text = "\(listOfJobs[indexPath.row].title) - \(payString)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedCell = indexPath.row
        return indexPath
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let requestURL: URL = URL(string: amazonKeyDelete + self.listOfJobs[indexPath.row].jid)!
            listOfJobs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            var request = URLRequest(url: requestURL)
            request.httpMethod = "DELETE"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                if error != nil {
                    OperationQueue.main.addOperation {
                        self.presentErrorNotification(errorTitle: "Application not deleted.", errorMessage: (error?.localizedDescription)!)
                    }
                } else {
                    do {
                        guard let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] else { return }
                        
                        guard let errors = json?["errors"] as? [[String: Any]] else { return }
                        if errors.count > 0 {
                            OperationQueue.main.addOperation {
                                self.presentErrorNotification(errorTitle: "Application not deleted.", errorMessage: "Your application was not deleted due to a network error.")
                            }
                            return
                        } else {
                            
                        }
                    }
                }
            })
            task.resume()
            OperationQueue.main.addOperation {
                self.presentErrorNotification(errorTitle: "Successfully deleted application.", errorMessage: "Your application has been deleted.")
            }

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    //a utility function for presenting an error notification to the user
    func presentErrorNotification(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewMyPostedJob" {
            let backButton = UIBarButtonItem()
            backButton.title = "Back"
            self.navigationItem.backBarButtonItem = backButton
            let nextVC = segue.destination as! ApplicantsViewController
            nextVC.selectedJob = listOfJobs[selectedCell]
            nextVC.title = listOfJobs[selectedCell].title
            nextVC.loggedInUser = self.loggedInUser!
        }
    }

}
