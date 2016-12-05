//
//  PostedJobsTableViewController.swift
//  uService
//
//  Created by Kendrick Choate on 12/4/16.
//  Copyright © 2016 Kendrick Choate. All rights reserved.
//

import UIKit

class PostedJobsTableViewController: UITableViewController {
    var listOfJobs: [Job] = []
    var selectedCell: Int = 0
    let colorDarkGreen = UIColor(colorLiteralRed: 62/255, green: 137/255, blue: 20/255, alpha: 1)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorColor = colorDarkGreen
        let job1 = Job(newJID: "ABC", newTitle: "Test 1", newLocation: "Houston, TX", newPay: 20.00, newDescription: "Test description 1", newDueDate: 1479423103, newDate: 1479423103)
        let job2 = Job(newJID: "ABC", newTitle: "Test 2", newLocation: "Houston, TX", newPay: 20.00, newDescription: "Test description 2", newDueDate: 1479423103, newDate: 1479423103)
        let job3 = Job(newJID: "ABC", newTitle: "Test 3", newLocation: "Houston, TX", newPay: 20.00, newDescription: "Test description 3", newDueDate: 1479423103, newDate: 1479423103)
        let job4 = Job(newJID: "ABC", newTitle: "Test 4", newLocation: "Houston, TX", newPay: 20.00, newDescription: "Test description 4", newDueDate: 1479423103, newDate: 1479423103)
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
        }
    }
}
