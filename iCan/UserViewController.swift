//
//  UserViewController.swift
//  uService
//

import UIKit
class user {
    var userID: Int
    var firstName: String
    var lastName: String
    var emailAddress: String?
    var phoneNumber: Int?
    var userRating: Int
    init () {
        userID = 0
        firstName = ""
        lastName = ""
        emailAddress = nil
        phoneNumber = nil
        userRating = 0
    }
}
class UserViewController: UIViewController {
    var loggedInUser: LoggedInUser? = nil
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = "\((loggedInUser?.firstName)!) \((loggedInUser?.lastName)!)"
        emailLabel.text = (loggedInUser?.email)!
        locationLabel.text = "\((loggedInUser?.city)!), \((loggedInUser?.state)!), \((loggedInUser?.zip)!)"
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
    }
    
}
