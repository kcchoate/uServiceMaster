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
    var listOfJobs: [Job] = []
    let colorDarkGreen = UIColor(colorLiteralRed: 62/255, green: 137/255, blue: 20/255, alpha: 1)
    override func viewDidLoad() {
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorColor = colorDarkGreen
        super.viewDidLoad()
        let job1 = Job(newJID: "ABC", newTitle: "Test 1", newLocation: "Houston, TX", newPay: 20.00, newDescription: "Test description", newDueDate: 1479423103, newDate: 1479423103)
        let job2 = Job(newJID: "ABC", newTitle: "Test 2", newLocation: "Houston, TX", newPay: 20.00, newDescription: "Test description", newDueDate: 1479423103, newDate: 1479423103)
        let job3 = Job(newJID: "ABC", newTitle: "Test 3", newLocation: "Houston, TX", newPay: 20.00, newDescription: "Test description", newDueDate: 1479423103, newDate: 1479423103)
        let job4 = Job(newJID: "ABC", newTitle: "Test 4", newLocation: "Houston, TX", newPay: 20.00, newDescription: "Test description", newDueDate: 1479423103, newDate: 1479423103)
        listOfJobs.append(job1)
        listOfJobs.append(job2)
        listOfJobs.append(job3)
        listOfJobs.append(job4)
        //TODO: - Pull all applications by the user from the server and populate them into the list of jobs (use dispatch.async. See: )
        /*      let requestURL: URL = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&units=imperial&appid=0e2a60aad888c1b78b8e73acaf987b57")!
         let urlRequest: URLRequest = URLRequest(url: requestURL)
         let session = URLSession.shared
         let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
         guard error == nil else {
         print ("Error calling GET")
         print (error)
         return
         }
         guard let responseData = data else {
         print ("Error: did not receive data")
         return
         }
         do {
         let json = try JSONSerialization.jsonObject(with: responseData, options: []) as! NSDictionary
         print (json)
         let tempCloudArray = json["weather"] as! NSArray
         let tempCloudDict = tempCloudArray[0] as! NSDictionary
         let tempCloud = tempCloudDict["description"] as! String
         self.cloud = tempCloud
         let tempDict = json["main"] as! NSDictionary
         let tempTemp = tempDict["temp"] as! Double
         self.temp = "\(tempTemp) F"
         let tempHumidity = tempDict["humidity"] as! Double
         self.humidity = "\(tempHumidity)%"
         let tempWindDict = json["wind"] as! NSDictionary
         let tempWind = tempWindDict["speed"] as! Double
         self.wind = "\(tempWind) mph"
         
         DispatchQueue.main.async {
         self.tempLabel.text = self.temp
         self.humidityLabel.text = self.humidity
         self.windSpeedLabel.text = self.wind
         self.cloudLabel.text = self.cloud
         }
         
         }
         catch {
         print ("Error trying to convert data to json")
         return
         }
         })
         task.resume()
         */
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.editButtonItem.title = "Delete"
        self.navigationItem.rightBarButtonItem = self.editButtonItem
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
