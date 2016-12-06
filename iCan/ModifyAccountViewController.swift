//
//  ModifyAccountViewController.swift
//  uService
//
//  Created by Tyler Allen on 12/5/16.
//  Copyright © 2016 Kendrick Choate. All rights reserved.
//

import UIKit
import CoreLocation
import CoreGraphics


class ModifyAccountViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, CLLocationManagerDelegate {
    
    var loggedInUser: LoggedInUser? = nil
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var resumeTextView: UITextView!
    @IBOutlet weak var updateButton: UIButton!
    var backgroundGrey: UIColor? = nil
    let locationManager = CLLocationManager()
    var newLocationLongitude: CLLocationDegrees = 0
    var newLocationLatitude: CLLocationDegrees = 0
    var updatedLongitude = "0"
    var updatedLatitude = "0"
    var locationUpdated: Bool = false
    
    
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
        locationUpdated = true
        LoadingOverlay.shared.showOverlay(view: self.view)
        locationManager.requestLocation()
        LoadingOverlay.shared.hideOverlayView()
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 1
        numberFormatter.maximumFractionDigits = 1
        numberFormatter.minimumIntegerDigits = 2
        numberFormatter.maximumIntegerDigits = 2
        updatedLatitude = numberFormatter.string(from: NSNumber(value: newLocationLatitude))!
        updatedLongitude = numberFormatter.string(from: NSNumber(value: newLocationLongitude))!
    }
    
    @IBAction func updateButtonPressed() {
        var newPassword: String? = nil
        var newLong: String? = nil
        var newLat: String? = nil
        var newResume: String? = nil
        if (newPasswordTextField.text! == confirmPasswordTextField.text! && newPasswordTextField.text!.characters.count > 0) {
            newPassword = newPasswordTextField.text!
        }
        if (locationUpdated) {
            newLong = updatedLongitude
            newLat = updatedLatitude
        }
        if (resumeTextView.text!.characters.count > 0) {
            newResume = resumeTextView.text!
        }
        //TODO: - Send updated information 
    }
    
    
    
    
    //a utility function for presenting an error notification to the user
    func presentErrorNotification(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alert: UIAlertAction!)  in
            self.performSegue(withIdentifier: "backUserAccount", sender: self)
        }))
        
        present(ac, animated: true)
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
            
        }
        if textField == confirmPasswordTextField
        {
            let oldStr = confirmPasswordTextField.text! as NSString
            let newStr = oldStr.replacingCharacters(in: range, with: string) as NSString
            if newStr.length == 0 || newPasswordTextField.text!.characters.count == 0 || newStr as String != newPasswordTextField.text
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
        if newPasswordTextField.text!.characters.count == 0 || confirmPasswordTextField.text!.characters.count == 0 || newPasswordTextField.text != confirmPasswordTextField.text
        {
            updateButton.isEnabled = false
        }
        else {
            updateButton.isEnabled = true
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
