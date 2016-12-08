//
//  LoginViewController.swift
//  uService
//

import UIKit

class LoggedInUser {
    var uid: String? = "Test"
    var firstName: String? = "First"
    var lastName: String? = "Last"
    var email: String? = "example@example.com"
    var password: String? = "Test"
    var resume: String? = "Test"
    var lat: Double? = 47.6
    var long: Double? = -122.3
    
    init(UID: String, FirstName: String, LastName: String, Password: String, Email: String, Lat: Double, Long: Double, Resume: String) {
        uid = UID
        firstName = FirstName
        lastName = LastName
        email = Email
        lat = Lat
        long = Long
        password = Password
        resume = Resume
    }
    init() {
        //default constructor used for testing
    }
}
class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextLabel: UITextField!
    @IBOutlet weak var passwordTextLabel: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    let colorDarkGreen = UIColor(colorLiteralRed: 62/255, green: 137/255, blue: 20/255, alpha: 1)
    
    let amazonKey: String = "https://0944tu0fdb.execute-api.us-west-2.amazonaws.com/prod/"
    var loggedInUser = LoggedInUser()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.isEnabled = false
        usernameTextLabel.delegate = self
        passwordTextLabel.delegate = self
        
        //toolbar setup for login page
        let usernameCloseToolBar = UIToolbar()
        usernameCloseToolBar.barStyle = .default
        usernameCloseToolBar.isTranslucent = true
        usernameCloseToolBar.tintColor = colorDarkGreen
        usernameCloseToolBar.sizeToFit()
        let usernameDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(usernameOKClicked))
        let usernameSpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let usernameCancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(usernameCancelClicked))
        usernameCloseToolBar.setItems([usernameCancelButton, usernameSpaceButton, usernameDoneButton], animated: false)
        usernameCloseToolBar.isUserInteractionEnabled = true
        usernameTextLabel.inputAccessoryView = usernameCloseToolBar
        
        let passwordCloseToolBar = UIToolbar()
        passwordCloseToolBar.barStyle = .default
        passwordCloseToolBar.isTranslucent = true
        passwordCloseToolBar.tintColor = colorDarkGreen
        passwordCloseToolBar.sizeToFit()
        let passwordDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(passwordOKClicked))
        let passwordSpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let passwordCancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(passwordCancelClicked))
        passwordCloseToolBar.setItems([passwordCancelButton, passwordSpaceButton, passwordDoneButton], animated: false)
        passwordCloseToolBar.isUserInteractionEnabled = true
        passwordTextLabel.inputAccessoryView = passwordCloseToolBar

        self.hideKeyboardWhenTappedAround() 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func usernameOKClicked() {
        usernameTextLabel.resignFirstResponder()
        passwordTextLabel.becomeFirstResponder()
    }
    func usernameCancelClicked() {
        usernameTextLabel.text = ""
        usernameTextLabel.resignFirstResponder()
    }
    func passwordOKClicked() {
        passwordTextLabel.resignFirstResponder()
    }
    func passwordCancelClicked() {
        passwordTextLabel.text = ""
        passwordTextLabel.resignFirstResponder()
    }
    
    @IBAction func LoginPressed() {
        testLogin(userName: usernameTextLabel.text!, password: passwordTextLabel.text!)
    }
    
    func testLogin(userName: String, password: String) {
        let requestURL: URL = URL(string: amazonKey + "users?uid=" + userName + "&password=" + password)!
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
            let parsedData = try JSONSerialization.jsonObject(with: responseData, options: []) as! [String:Any]
            let data = parsedData["data"] as! [String:Any]
            if (data.count > 0) {
                DispatchQueue.main.async {
                    let attributes = data["attributes"] as! [String:Any]
                    let properties = attributes["properties"] as! [String:Any]
                    self.loggedInUser.uid = properties["email"] as? String
                    self.loggedInUser.firstName = properties["firstname"] as? String
                    self.loggedInUser.lastName = properties["lastname"] as? String
                    self.loggedInUser.lat = attributes["latitude"] as? Double
                    self.loggedInUser.long = attributes["longitude"] as? Double
                    self.loggedInUser.password = attributes["password"] as? String
                    var userResume = "none"
                    if properties["resume"] != nil{
                        userResume = properties["resume"] as! String
                    }
                    self.loggedInUser.resume = userResume
                    self.performSegue(withIdentifier: "LoginSuccess", sender: self)
                }
            }
            else {
                //we have to manually add the pop up view to the main thread to prevent an error caused by views appearing from threads other than the main one
                OperationQueue.main.addOperation {
                    self.presentErrorNotification(errorTitle: "Invalid login", errorMessage: "Your username/password was not recognized.")
                }
            }
            
            
        }
        catch {
            print ("Error trying to convert data to json")
            return
        }
        
        })
        task.resume()
    }
    
    //a utility function for presenting an error notification to the user
    func presentErrorNotification(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    // MARK: - Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // The next two if statements disable the login button until information is entered into the username and password fields
        
        if textField == usernameTextLabel
        {
            let oldStr = usernameTextLabel.text! as NSString
            let newStr = oldStr.replacingCharacters(in: range, with: string) as NSString
            if (newStr.length == 0 || passwordTextLabel.text!.characters.count == 0) {
                loginButton.isEnabled = false
            }
            else {
                loginButton.isEnabled = true
            }
        }
        if textField == passwordTextLabel
        {
            let oldStr = passwordTextLabel.text! as NSString
            let newStr = oldStr.replacingCharacters(in: range, with: string) as NSString
            if (newStr.length == 0 || usernameTextLabel.text!.characters.count == 0) {
                loginButton.isEnabled = false
            }
            else {
                loginButton.isEnabled = true
            }
        }
        return true
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginSuccess" {
            let destinationVC = segue.destination as! TabBarController
            destinationVC.loggedInUser = self.loggedInUser
            let firstNavController = destinationVC.viewControllers?[0] as! LoggedInNavigationController
            let userViewController = firstNavController.viewControllers[0] as! UserViewController
            userViewController.loggedInUser = self.loggedInUser
            let secondNavController = destinationVC.viewControllers?[1] as! LoggedInNavigationController
            let newJobViewController = secondNavController.viewControllers[0] as! NewJobViewController
            newJobViewController.loggedInUser = self.loggedInUser
            let thirdNavController = destinationVC.viewControllers?[2] as! LoggedInNavigationController
            let findJobViewController = thirdNavController.viewControllers[0] as! PostedJobsTableViewController
            findJobViewController.loggedInUser = self.loggedInUser
        }
    }
/* 
 The icons we use for the tab bar come from a website that asks us to link to each icon in our About page. The links are as such:
 search: https://icons8.com/web-app/5269/search-property
 home: https://icons8.com/web-app/73/home
 post: https://icons8.com/web-app/7989/currency#filled
 settings: https://icons8.com/web-app/14099/settings
*/
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
