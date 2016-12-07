//
//  MyApplicationsTableViewController.swift
//  uService
//
//  Created by Kendrick Choate on 12/4/16.
//  Copyright © 2016 Kendrick Choate. All rights reserved.
//

import UIKit

class MyApplicationsTableViewController: UITableViewController {
    var selectedCell: Int = 0
    var loggedInUser: LoggedInUser? = nil
    var listOfJobs: [Job] = []
    let colorDarkGreen = UIColor(colorLiteralRed: 62/255, green: 137/255, blue: 20/255, alpha: 1)
    let amazonKey = "https://0944tu0fdb.execute-api.us-west-2.amazonaws.com/prod/applications?applicant="
    override func viewDidLoad() {
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorColor = colorDarkGreen
        super.viewDidLoad()
        self.editButtonItem.title = "Delete"
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        updateJobList()
    }
    
    func updateJobList() {
        //TODO: Uncomment next line once UIDs have been updated from base64 to email addresses
        //let requestURL: URL = URL(string: amazonKey + (loggedInUser?.uid)!)!\
        let requestURL: URL = URL(string: "\(amazonKey)amjAc8OK")!
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
        
        cell.textLabel?.text = "\(listOfJobs[indexPath.row].title) - $\(listOfJobs[indexPath.row].pay)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedCell = indexPath.row
        return indexPath
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            listOfJobs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            // TODO: - send request to server to delete application
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "viewSelectedApplication") {
            let destinationVC = segue.destination as! SelectedApplicationViewController
            destinationVC.selectedJob = listOfJobs[selectedCell]
            destinationVC.title = listOfJobs[selectedCell].title
            
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
        }
     }
    


}
