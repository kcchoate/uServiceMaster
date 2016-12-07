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
    let colorDarkGreen = UIColor(colorLiteralRed: 62/255, green: 137/255, blue: 20/255, alpha: 1)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorColor = colorDarkGreen
        let job1 = Job(JID: "ABC", Title: "Houston Job", Longitude: -95.4, Latitude: 29.8, Pay: 20.00, Description: "Test description", DueDate: 1479423103, PostDate: 1479423103)
        let job2 = Job(JID: "ABC", Title: "Seattle Job", Longitude: -122.3, Latitude: 47.6, Pay: 20.00, Description: "Test description", DueDate: 1479423103, PostDate: 1479423103)
        let job3 = Job(JID: "ABC", Title: "New York Job", Longitude: -74.0, Latitude: 40.7, Pay: 20.00, Description: "Test description", DueDate: 1479423103, PostDate: 1479423103)
        let job4 = Job(JID: "ABC", Title: "Raleigh Job", Longitude: -78.6, Latitude: 35.8, Pay: 20.00, Description: "Test description", DueDate: 1479423103, PostDate: 1479423103)
        //TODO: Retrieve all jobs from server
        listOfJobs.append(job1)
        listOfJobs.append(job2)
        listOfJobs.append(job3)
        listOfJobs.append(job4)
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
