//
//  LoginViewController.swift
//  uService
//

import UIKit

class LoggedInUser {
    var UID: String? = nil
}
class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextLabel: UITextField!
    @IBOutlet weak var passwordTextLabel: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    let amazonKey: String = "https://0944tu0fdb.execute-api.us-west-2.amazonaws.com/prod/"
    var loggedInUser: LoggedInUser? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.isEnabled = false
        usernameTextLabel.delegate = self
        passwordTextLabel.delegate = self
        /*let requestURL: URL = URL(string: "https://0944tu0fdb.execute-api.us-west-2.amazonaws.com/prod/jobs")!
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
                let json = try JSONSerialization.jsonObject(with: responseData, options: []) as! NSDictionary
                print (json)
                print ("done")
            }
            catch {
                print ("Error trying to convert data to json")
                return
            }
            
        })
        task.resume()*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func LoginPressed() {
        if (usernameTextLabel.text == nil || passwordTextLabel.text == nil || usernameTextLabel.text == "" || passwordTextLabel.text == "") {
            presentErrorNotification(errorTitle: "Invalid Login", errorMessage: "Username or password left blank.")
        }
        else if (testLogin(userName: usernameTextLabel.text!, password: passwordTextLabel.text!)) {
            performSegue(withIdentifier: "LoginSuccess", sender: self)
        }
        else {
            presentErrorNotification(errorTitle: "Invalid Login", errorMessage: "Your username/password combination was not recognized.")
        }
    }
    
    func testLogin(userName: String, password: String) -> Bool{
        //send username+password to server
        //retrieve data
        //check for response T or F
        //if T: 
            //save user info
            //return true
        //if F:
            //return false
        return false
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
