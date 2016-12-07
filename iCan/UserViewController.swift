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
        let userLocation = CLLocation(latitude: (loggedInUser?.lat)!, longitude: (loggedInUser?.long)!)
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
        
        nameLabel.text = "\((loggedInUser?.firstName)!) \((loggedInUser?.lastName)!)"
        emailLabel.text = (loggedInUser?.email)!
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
    }
    
}
