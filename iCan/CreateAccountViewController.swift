//
//  CreateAccountViewController.swift
//  uService
//
//  Created by Tyler Allen on 11/23/16.
//  Copyright © 2016 Kendrick Choate. All rights reserved.
//

import UIKit
import CoreLocation

class CreateAccountViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordVerificationTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var resumeTextView: UITextView!
    @IBOutlet weak var createButton: UIButton!
    let colorDarkGreen = UIColor(colorLiteralRed: 62/255, green: 137/255, blue: 20/255, alpha: 1)
    var backgroundGrey: UIColor? = nil
    let locationManager = CLLocationManager()
    var locationLongitude: CLLocationDegrees = 0
    var locationLatitude: CLLocationDegrees = 0
    
    override func viewDidLoad() {
        backgroundGrey = passwordTextField.backgroundColor
        super.viewDidLoad()
        createButton.isEnabled = false
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordVerificationTextField.delegate = self
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        resumeTextView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
        
        // setting up toolbars for text entry
        
        let emailCloseToolBar = UIToolbar()
        emailCloseToolBar.barStyle = .default
        emailCloseToolBar.isTranslucent = true
        emailCloseToolBar.tintColor = colorDarkGreen
        emailCloseToolBar.sizeToFit()
        let emailDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(emailOKClicked))
        let emailSpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let emailCancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(emailCancelClicked))
        emailCloseToolBar.setItems([emailCancelButton, emailSpaceButton, emailDoneButton], animated: false)
        emailCloseToolBar.isUserInteractionEnabled = true
        emailTextField.inputAccessoryView = emailCloseToolBar
        
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
        passwordTextField.inputAccessoryView = passwordCloseToolBar
        
        let passwordVerificationCloseToolBar = UIToolbar()
        passwordVerificationCloseToolBar.barStyle = .default
        passwordVerificationCloseToolBar.isTranslucent = true
        passwordVerificationCloseToolBar.tintColor = colorDarkGreen
        passwordVerificationCloseToolBar.sizeToFit()
        let passwordVerificationDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(passwordVerificationOKClicked))
        let passwordVerificationSpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let passwordVerificationCancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(passwordVerificationCancelClicked))
        passwordVerificationCloseToolBar.setItems([passwordVerificationCancelButton, passwordVerificationSpaceButton, passwordVerificationDoneButton], animated: false)
        passwordVerificationCloseToolBar.isUserInteractionEnabled = true
        passwordVerificationTextField.inputAccessoryView = passwordVerificationCloseToolBar
        
        let firstNameCloseToolBar = UIToolbar()
        firstNameCloseToolBar.barStyle = .default
        firstNameCloseToolBar.isTranslucent = true
        firstNameCloseToolBar.tintColor = colorDarkGreen
        firstNameCloseToolBar.sizeToFit()
        let firstNameDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(firstNameOKClicked))
        let firstNameSpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let firstNameCancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(firstNameCancelClicked))
        firstNameCloseToolBar.setItems([firstNameCancelButton, firstNameSpaceButton, firstNameDoneButton], animated: false)
        firstNameCloseToolBar.isUserInteractionEnabled = true
        firstNameTextField.inputAccessoryView = firstNameCloseToolBar
        
        let lastNameCloseToolBar = UIToolbar()
        lastNameCloseToolBar.barStyle = .default
        lastNameCloseToolBar.isTranslucent = true
        lastNameCloseToolBar.tintColor = colorDarkGreen
        lastNameCloseToolBar.sizeToFit()
        let lastNameDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(lastNameOKClicked))
        let lastNameSpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let lastNameCancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(lastNameCancelClicked))
        lastNameCloseToolBar.setItems([lastNameCancelButton, lastNameSpaceButton, lastNameDoneButton], animated: false)
        lastNameCloseToolBar.isUserInteractionEnabled = true
        lastNameTextField.inputAccessoryView = lastNameCloseToolBar
        
        let resumeCloseToolBar = UIToolbar()
        resumeCloseToolBar.barStyle = .default
        resumeCloseToolBar.isTranslucent = true
        resumeCloseToolBar.tintColor = colorDarkGreen
        resumeCloseToolBar.sizeToFit()
        let resumeDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(resumeOKClicked))
        let resumeSpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let resumeCancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(resumeCancelClicked))
        resumeCloseToolBar.setItems([resumeCancelButton, resumeSpaceButton, resumeDoneButton], animated: false)
        resumeCloseToolBar.isUserInteractionEnabled = true
        resumeTextView.inputAccessoryView = resumeCloseToolBar
        
        locationManager.requestWhenInUseAuthorization()
        self.hideKeyboardWhenTappedAround()
    }
    
    func emailOKClicked() {
        emailTextField.resignFirstResponder()
        passwordTextField.becomeFirstResponder()
    }
    func emailCancelClicked() {
        emailTextField.text = ""
        emailTextField.resignFirstResponder()
    }
    func passwordOKClicked() {
        passwordTextField.resignFirstResponder()
        passwordVerificationTextField.becomeFirstResponder()
    }
    func passwordCancelClicked() {
        passwordTextField.text = ""
        passwordTextField.resignFirstResponder()
    }
    func passwordVerificationOKClicked() {
        passwordVerificationTextField.resignFirstResponder()
        firstNameTextField.becomeFirstResponder()
    }
    func passwordVerificationCancelClicked() {
        passwordVerificationTextField.text = ""
        passwordVerificationTextField.resignFirstResponder()
    }
    func firstNameOKClicked() {
        firstNameTextField.resignFirstResponder()
        lastNameTextField.becomeFirstResponder()
    }
    func firstNameCancelClicked() {
        firstNameTextField.text = ""
        firstNameTextField.resignFirstResponder()
    }
    func lastNameOKClicked() {
        lastNameTextField.resignFirstResponder()
        resumeTextView.becomeFirstResponder()
    }
    func lastNameCancelClicked() {
        lastNameTextField.text = ""
        lastNameTextField.resignFirstResponder()
    }
    func resumeOKClicked() {
        resumeTextView.resignFirstResponder()
    }
    func resumeCancelClicked() {
        resumeTextView.text = ""
        resumeTextView.resignFirstResponder()
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func createButtonPressed() {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 1
        numberFormatter.maximumFractionDigits = 1
        numberFormatter.minimumIntegerDigits = 2
        numberFormatter.maximumIntegerDigits = 2
        let savedLatitude = numberFormatter.string(from: NSNumber(value: locationLatitude))!
        let savedLongitude = numberFormatter.string(from: NSNumber(value: locationLongitude))!
        //TODO: - Send new user to server
    }
    
    
    
    //a utility function for presenting an error notification to the user
    func presentErrorNotification(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alert: UIAlertAction!)  in
            self.performSegue(withIdentifier: "backToLoginSegue", sender: self)
        }))
        
        present(ac, animated: true)
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if emailTextField.text!.characters.count == 0 || passwordTextField.text!.characters.count == 0 || passwordVerificationTextField.text!.characters.count == 0 || firstNameTextField.text!.characters.count == 0 || lastNameTextField.text!.characters.count == 0 || passwordVerificationTextField.text != passwordTextField.text
        {
            createButton.isEnabled = false
        }
        else {
            createButton.isEnabled = true
        }
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // The next five if statements test the textfields for text to verify that all fields have text in them each time the text field is changed. If any don't have text, the addJobButton is disabled
        
        if textField == emailTextField
        {
            let oldStr = emailTextField.text! as NSString
            let newStr = oldStr.replacingCharacters(in: range, with: string) as NSString
            if newStr.length == 0 || passwordTextField.text!.characters.count == 0 || passwordVerificationTextField.text!.characters.count == 0 || firstNameTextField.text!.characters.count == 0 || lastNameTextField.text!.characters.count == 0 || passwordVerificationTextField.text != passwordTextField.text
            {
                createButton.isEnabled = false
            }
            else {
                createButton.isEnabled = true
            }
        }
        if textField == passwordTextField
        {
            let oldStr = passwordTextField.text! as NSString
            let newStr = oldStr.replacingCharacters(in: range, with: string) as NSString
            if newStr.length == 0 || emailTextField.text!.characters.count == 0 || passwordVerificationTextField.text!.characters.count == 0 || firstNameTextField.text!.characters.count == 0 || lastNameTextField.text!.characters.count == 0 || passwordVerificationTextField.text != newStr as String
            {
                createButton.isEnabled = false
            }
            else {
                createButton.isEnabled = true
            }
            if newStr as String != passwordVerificationTextField.text! && passwordVerificationTextField.text!.characters.count > 0 {
                passwordTextField.backgroundColor = UIColor.red
                passwordVerificationTextField.backgroundColor = UIColor.red
            }
            else {
                
                passwordTextField.backgroundColor = backgroundGrey
                passwordVerificationTextField.backgroundColor = backgroundGrey
            }
            
        }
        if textField == passwordVerificationTextField
        {
            let oldStr = passwordVerificationTextField.text! as NSString
            let newStr = oldStr.replacingCharacters(in: range, with: string) as NSString
            if newStr.length == 0 || emailTextField.text!.characters.count == 0 || passwordTextField.text!.characters.count == 0 || firstNameTextField.text!.characters.count == 0 || lastNameTextField.text!.characters.count == 0 || newStr as String != passwordTextField.text
            {
                createButton.isEnabled = false
            }
            else {
                createButton.isEnabled = true
            }
            if newStr as String != passwordTextField.text! {
                passwordTextField.backgroundColor = UIColor.red
                passwordVerificationTextField.backgroundColor = UIColor.red
            }
            else {
                
                passwordTextField.backgroundColor = backgroundGrey
                passwordVerificationTextField.backgroundColor = backgroundGrey
                
            }
        }
        if textField == firstNameTextField
        {
            let oldStr = firstNameTextField.text! as NSString
            let newStr = oldStr.replacingCharacters(in: range, with: string) as NSString
            if newStr.length == 0 || emailTextField.text!.characters.count == 0 || passwordTextField.text!.characters.count == 0 || passwordVerificationTextField.text!.characters.count == 0 || lastNameTextField.text!.characters.count == 0 || passwordVerificationTextField.text != passwordTextField.text
            {
                createButton.isEnabled = false
            }
            else {
                createButton.isEnabled = true
            }
        }
        if textField == lastNameTextField
        {
            let oldStr = lastNameTextField.text! as NSString
            let newStr = oldStr.replacingCharacters(in: range, with: string) as NSString
            if newStr.length == 0 || emailTextField.text!.characters.count == 0 || passwordTextField.text!.characters.count == 0 || passwordVerificationTextField.text!.characters.count == 0 || firstNameTextField.text!.characters.count == 0 || passwordVerificationTextField.text != passwordTextField.text
            {
                createButton.isEnabled = false
            }
            else {
                createButton.isEnabled = true
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
        if status == .authorizedWhenInUse {
            print ("authorized When In Use")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        self.locationLatitude = location.coordinate.latitude
        self.locationLongitude = location.coordinate.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        presentErrorNotification(errorTitle: "Error in retrieving location.", errorMessage: error.localizedDescription)
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
