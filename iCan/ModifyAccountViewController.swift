//
//  ModifyAccountViewController.swift
//  uService
//
//  Created by Tyler Allen on 12/5/16.
//  Copyright © 2016 Kendrick Choate. All rights reserved.
//

import UIKit
import CoreLocation

protocol SendLoggedInUserBack {
    func loggedInUserSentBack(sender: ModifyAccountViewController)
}
class ModifyAccountViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var resumeTextView: UITextView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var newLocationSwitch: UISwitch!
    let amazonKey = "https://0944tu0fdb.execute-api.us-west-2.amazonaws.com/prod/users/"
    var loggedInUser: LoggedInUser? = nil
    var backgroundGrey: UIColor? = nil
    let locationManager = CLLocationManager()
    var newLocationLongitude: CLLocationDegrees = 0
    var newLocationLatitude: CLLocationDegrees = 0
    var updatedLongitude: Double = 0
    var updatedLatitude: Double = 0
    var locationUpdated: Bool = false
    var sendLoggedInUserBackDelegate: SendLoggedInUserBack? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundGrey = newPasswordTextField.backgroundColor
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        newPasswordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        resumeTextView.delegate = self
        updateButton.isEnabled = false
        updatedLongitude = (loggedInUser?.long)!
        updatedLatitude = (loggedInUser?.lat)!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func newLocationSwitchOn() {
        if (newLocationSwitch.isOn) {
            locationUpdated = true
            LoadingOverlay.shared.showOverlay(view: self.view)
            locationManager.requestLocation()
            LoadingOverlay.shared.hideOverlayView()
            let numberFormatter = NumberFormatter()
            numberFormatter.minimumFractionDigits = 1
            numberFormatter.maximumFractionDigits = 1
            numberFormatter.minimumIntegerDigits = 2
            numberFormatter.maximumIntegerDigits = 2
            updatedLatitude = newLocationLatitude
            updatedLongitude = newLocationLongitude
            
            if (newPasswordTextField.text! != confirmPasswordTextField.text!) {
                updateButton.isEnabled = false
            }
            else {
                updateButton.isEnabled = true
            }
        }
        else {
            locationUpdated = false
            if ( (newPasswordTextField.text! == confirmPasswordTextField.text! && newPasswordTextField.text!.characters.count > 0) || resumeTextView.text.characters.count > 0 ) {
                updateButton.isEnabled = true
            }
            else {
                updateButton.isEnabled = false
            }
        }
    }
    
    @IBAction func updateButtonPressed() {
        var newPassword: String? = nil
        var newLong: Double? = nil
        var newLat: Double? = nil
        var newResume: String? = nil
        if (newPasswordTextField.text! == confirmPasswordTextField.text! && newPasswordTextField.text!.characters.count > 0) {
            newPassword = newPasswordTextField.text!
        }
        else {
            newPassword = (self.loggedInUser?.password)!
        }
        if (locationUpdated) {
            newLong = updatedLongitude
            newLat = updatedLatitude
        }
        else {
            newLong = (self.loggedInUser?.long)!
            newLat = (self.loggedInUser?.lat)!
        }
        if (resumeTextView.text!.characters.count > 0) {
            newResume = resumeTextView.text!
        }
        else {
            newResume = (self.loggedInUser?.resume)!
        }
        self.loggedInUser?.password = newPassword
        self.loggedInUser?.lat = newLat
        self.loggedInUser?.long = newLong
        self.loggedInUser?.resume = newResume
        let newJob = [
            
            "data": [
                "type": "users",
                "uid": (self.loggedInUser?.uid)!,
                "attributes": [
                    "password": newPassword!,
                    "resume": newResume!,
                    "latitude": newLat!,
                    "longitude": newLong!
                ]
            ]
        ] as [String: Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: newJob, options: [.prettyPrinted])
        let requestURL: URL = URL(string: amazonKey + (self.loggedInUser?.uid)!)!
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PATCH"
        request.httpBody = jsonData
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                OperationQueue.main.addOperation {
                    self.presentErrorNotification(errorTitle: "Your profile failed to update", errorMessage: (error?.localizedDescription)!)
                }
            } else {
                do {
                    guard let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] else { return }
                    
                    guard let errors = json?["errors"] as? [[String: Any]] else { return }
                    if errors.count > 0 {
                        OperationQueue.main.addOperation {
                            self.presentErrorNotification(errorTitle: "Your profile failed to update", errorMessage: "Applicant accept failed due to a network error.")
                        }
                        return
                    } else {
                        
                    }
                }
            }
        })
        task.resume()
        OperationQueue.main.addOperation {
            self.presentErrorNotification(errorTitle: "Profile updated", errorMessage: "You have sucessfully updated your profile.")
        }
        
    }
    
    //a utility function for presenting an error notification to the user
    func presentErrorNotification(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    @IBAction func backButtonPressed() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // The next three if statements test the textfields for text to verify that all fields have text in them each time the text field is changed. If any don't have text, the addJobButton is disabled
        
        if textField == newPasswordTextField
        {
            let oldStr = newPasswordTextField.text! as NSString
            let newStr = oldStr.replacingCharacters(in: range, with: string) as NSString
            if newStr.length == 0 || confirmPasswordTextField.text!.characters.count == 0 || confirmPasswordTextField.text != newStr as String
            {
                updateButton.isEnabled = false
            }
            else {
                updateButton.isEnabled = true
            }
            if newStr as String != confirmPasswordTextField.text! && confirmPasswordTextField.text!.characters.count > 0 {
                newPasswordTextField.backgroundColor = UIColor.red
                confirmPasswordTextField.backgroundColor = UIColor.red
            }
            else {
                
                newPasswordTextField.backgroundColor = backgroundGrey
                confirmPasswordTextField.backgroundColor = backgroundGrey
            }
            if (newStr.length == 0 && confirmPasswordTextField.text!.characters.count == 0 && (locationUpdated || resumeTextView.text.characters.count > 0)) {
                updateButton.isEnabled = true
            }
        }
        if textField == confirmPasswordTextField
        {
            let oldStr = confirmPasswordTextField.text! as NSString
            let newStr = oldStr.replacingCharacters(in: range, with: string) as NSString
            if (newStr.length == 0 || newPasswordTextField.text!.characters.count == 0 || newStr as String != newPasswordTextField.text)
            {
                updateButton.isEnabled = false
            }
            else {
                updateButton.isEnabled = true
            }
            if newStr as String != newPasswordTextField.text! {
                newPasswordTextField.backgroundColor = UIColor.red
                confirmPasswordTextField.backgroundColor = UIColor.red
            }
            else {
                
                newPasswordTextField.backgroundColor = backgroundGrey
                confirmPasswordTextField.backgroundColor = backgroundGrey
            }
            
            if (newStr.length == 0 && newPasswordTextField.text!.characters.count == 0 && (locationUpdated || resumeTextView.text.characters.count > 0)) {
                updateButton.isEnabled = true
            }
        }
        //and here we limit the text fields to a maximum of 25 characters
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= 25
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if newPasswordTextField.text == confirmPasswordTextField.text
        {
            updateButton.isEnabled = false
        }
        else {
            if (locationUpdated || resumeTextView.text!.characters.count > 0) {
                updateButton.isEnabled = true
            }
            else {
                updateButton.isEnabled = false
            }
        }
        
    }
    
    //make textfields close the keyboard when pressing the return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    //MARK: - UITextViewDelegate
    
    //limits the jobDetails field to maximum 300 characters
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count
        if ((numberOfChars > 0 || locationUpdated) && confirmPasswordTextField.text! == newPasswordTextField.text!) {
            updateButton.isEnabled = true
        }
        else {
            updateButton.isEnabled = false
        }
        return numberOfChars <= 280;
    }
    
    //MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        
        if status == .denied {
            presentErrorNotification(errorTitle: "Location is needed.", errorMessage: "In order to find and post jobs in your area you will need to provide location abilities in your settings.")
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        self.newLocationLatitude = location.coordinate.latitude
        self.newLocationLongitude = location.coordinate.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        presentErrorNotification(errorTitle: "Error in retrieving location.", errorMessage: error.localizedDescription)
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backUserAccount" {
            let nextVC = segue.destination as! UserViewController
            nextVC.loggedInUser = self.loggedInUser
        }
    }

}

public class LoadingOverlay{
    
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    public func showOverlay(view: UIView) {
        
        overlayView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        overlayView.center = view.center
        overlayView.backgroundColor = UIColor(red: 68, green: 68, blue: 68, alpha: 0.7)
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
        
        overlayView.addSubview(activityIndicator)
        view.addSubview(overlayView)
        
        activityIndicator.startAnimating()
    }
    
    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
}
