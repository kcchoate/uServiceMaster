//
//  MyJobsTableViewController.swift
//  uService
//
//  Created by Kendrick Choate on 12/4/16.
//  Copyright © 2016 Kendrick Choate. All rights reserved.
//

import UIKit
class Job {
    var jid: String
    var title: String
    var longitude: Double
    var latitude: Double
    var pay: Float
    var description: String
    var dueDate: Double
    var date: Double
    init (JID: String, Title: String, Longitude: Double, Latitude: Double, Pay: Float, Description: String, DueDate: Double, PostDate: Double) {
        //jUID, date, pay, title, description, duedate
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorColor = colorDarkGreen
        self.editButtonItem.title = "Delete"
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        updateJobList()
    }

    func updateJobList() {
        //TODO: Uncomment next line once UIDs have been updated from base64 to email addresses
        //let requestURL: URL = URL(string: amazonKey + (loggedInUser?.uid)!)!\
        let requestURL: URL = URL(string: "\(amazonKey)ireMURxJ")!
        print ((loggedInUser?.uid)!)
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
                dateFormatter.dateFormat = "MM/DD/YYYY"
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
                        let tempJobTitle = properties["title"] as! String
                        let tempJobLong = attributes["longitude"] as! Double
                        let tempJobLat = attributes["latitude"] as! Double
                        let tempJobPay = attributes["pay"] as! String
                        let tempJobDescription = properties["description"] as! String
                        let tempJobDueDate = properties["dueDate"] as! String
                        let tempJobDueDateFromApexTime = dateFormatter.date(from: tempJobDueDate)?.timeIntervalSince1970
                        let jobListing = Job(JID: tempJobJID, Title: tempJobTitle, Longitude: tempJobLong, Latitude: tempJobLat, Pay: Float(tempJobPay)!, Description: tempJobDescription, DueDate: tempJobDueDateFromApexTime!, PostDate: tempJobDate)
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
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            listOfJobs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            // TODO: - send request to server to delete job
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

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
        }
    }

}
