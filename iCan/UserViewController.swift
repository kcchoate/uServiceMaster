//
//  UserViewController.swift
//  uService
//

import UIKit
import CoreLocation
class UserViewController: UIViewController {
    var loggedInUser: LoggedInUser? = nil
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    let geocoder = CLGeocoder()
    var userCity = "Loading"
    var userState = "..."
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: - SWITCH LAT AND LONG BACK. SWITCHED THEM AS TEST DATA HAD IT SWITCHED
        let userLocation = CLLocation(latitude: (loggedInUser?.long)!, longitude: (loggedInUser?.lat)!)
        DispatchQueue.main.async {
            self.geocoder.reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) -> Void in
                let placemark = placemarks?[0]
                self.userCity = placemark?.addressDictionary!["City"] as! String
                self.userState = placemark?.addressDictionary!["State"] as! String
                self.locationLabel.text = "\(self.userCity), \(self.userState)"
                self.nameLabel.text = "\((self.loggedInUser?.firstName)!) \((self.loggedInUser?.lastName)!)"
                self.emailLabel.text = "\((self.loggedInUser?.uid)!)"
            })
        
        }
        //self.navigationController?.navigationBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        if segue.identifier == "userSettingsSegue" {
            let secondVC = segue.destination as! ModifyAccountViewController
            secondVC.loggedInUser = self.loggedInUser
        }
        if segue.identifier == "viewMyPostedJobs" {
            let secondVC = segue.destination as! MyJobsTableViewController
            secondVC.loggedInUser = self.loggedInUser
        }
        if segue.identifier == "viewMyApplications" {
            let secondVC = segue.destination as! MyApplicationsTableViewController
            secondVC.loggedInUser = self.loggedInUser
        }
    }
    
}
