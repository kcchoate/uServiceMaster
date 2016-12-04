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
    @IBOutlet weak var userImageOutlet: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print (loggedInUser!.UID!)
        //self.navigationController?.navigationBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
