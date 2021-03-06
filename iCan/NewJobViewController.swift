//
//  NewJobViewController.swift
//  uService
//
import UIKit

class NewJob {
    var owner: String
    var title: String
    var latitude: Double
    var longitude: Double
    var pay: Float
    var description: String
    var dueDate: String
    var date: Double
    init (newOwner: String, newTitle: String, newLongitude: Double, newLatitude: Double, newPay: Float, newDescription: String, newDueDate: String, newDate: Double) {
        //date, pay, title, description, duedate
        owner = newOwner
        title = newTitle
        longitude = newLongitude
        latitude = newLatitude
        dueDate = newDueDate
        pay = newPay
        description = newDescription
        date = newDate
    }
    init () {
        //default constructor used for testing
        owner = "Test job"
        title = "Test job"
        longitude = 0
        latitude = 0
        pay = 0
        description = "Test job"
        dueDate = "01/01/2012"
        date = 0
    }

}

class NewJobViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var jobPriceTextField: UITextField!
    @IBOutlet weak var jobDateTextField: UITextField!
    @IBOutlet weak var jobDetailsTextField: UITextView!
    @IBOutlet weak var bottomAddJobButton: UIButton!
    let colorDarkGreen = UIColor(colorLiteralRed: 62/255, green: 137/255, blue: 20/255, alpha: 1)
    let amazonKey = "https://0944tu0fdb.execute-api.us-west-2.amazonaws.com/prod/jobs"
    var loggedInUser: LoggedInUser? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomAddJobButton.isEnabled = false
        
        // We setup a different toolbar for the same functionality for the date selector
        let dateCloseToolBar = UIToolbar()
        dateCloseToolBar.barStyle = .default
        dateCloseToolBar.isTranslucent = true
        dateCloseToolBar.tintColor = colorDarkGreen
        dateCloseToolBar.sizeToFit()
        let dateDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(dateOKClicked))
        let dateSpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let dateCancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(dateCancelClicked))
        dateCloseToolBar.setItems([dateCancelButton, dateSpaceButton, dateDoneButton], animated: false)
        dateCloseToolBar.isUserInteractionEnabled = true
        jobDateTextField.inputAccessoryView = dateCloseToolBar
        
        //set the text field delegates to this controller, allowing us to enable/disable the add job button based on text entry as well as format the fields
        jobTitleTextField.delegate = self
        jobPriceTextField.delegate = self
        jobDateTextField.delegate = self
        
        //hide the keyboard when the user clicks on the screen
        self.hideKeyboardWhenTappedAround()
    }
    
    func dateOKClicked() {
        jobDateTextField.resignFirstResponder()
    }
    func dateCancelClicked() {
        jobDateTextField.text = ""
        jobDateTextField.resignFirstResponder()
    }
    
    
    @IBAction func addNewJobButtonPressed(_ sender: AnyObject) {
        let jobTitle = jobTitleTextField.text!
        let jobDetails = jobDetailsTextField.text!
        // The next lines format the price field
        let priceField = jobPriceTextField.text!
        let strippedPriceIndex = priceField.index(after: priceField.startIndex)
        let jobPriceWithCommas = priceField.substring(from: strippedPriceIndex)
        let jobPrice = Float(jobPriceWithCommas.replacingOccurrences(of: ",", with: ""))!
        // The next lines format the date field
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let dueDate = dateFormatter.date(from: jobDateTextField.text!)
        let dueDateStr = dateFormatter.string(from: dueDate!)
        let usersNewJob = NewJob(newOwner: (loggedInUser?.uid)!, newTitle: jobTitle, newLongitude: (loggedInUser?.long)!, newLatitude: (loggedInUser?.lat)!, newPay: jobPrice, newDescription: jobDetails, newDueDate: dueDateStr, newDate: Date.init().timeIntervalSince1970)
        
        
        let newJob = [
            
                "data": [
                    "type": "jobs",
                    "attributes": [
                        "owner": usersNewJob.owner,
                        "latitude": usersNewJob.latitude,
                        "longitude": usersNewJob.longitude,
                        "description": usersNewJob.description,
                        "title":usersNewJob.title,
                        "dueDate": usersNewJob.dueDate,
                        "pay": String(usersNewJob.pay)
                    ]
                ]
            
            ] as [String: Any]
        let jsonData = try! JSONSerialization.data(withJSONObject: newJob, options: [.prettyPrinted])
        let requestURL: URL = URL(string: amazonKey)!
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                OperationQueue.main.addOperation {
                    self.presentErrorNotification(errorTitle: "Job not created", errorMessage: (error?.localizedDescription)!)
                }
            } else {
                do {
                    guard let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] else { return }
                    
                    guard let errors = json?["errors"] as? [[String: Any]] else { return }
                    if errors.count > 0 {
                        OperationQueue.main.addOperation {
                            self.presentErrorNotification(errorTitle: "Job not sent", errorMessage: "Your job was not sent due to a network error.")
                        }
                        return
                    } else {
                        
                    }
                }
            }
        })
        task.resume()
        OperationQueue.main.addOperation {
            self.presentErrorNotification(errorTitle: "Successfully Posted Job", errorMessage: "Your job has been added")
        }
        resetForm()
    }
    //a utility function for presenting an error notification to the user
    func presentErrorNotification(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func resetForm() {
        self.jobTitleTextField.text = ""
        self.jobDateTextField.text = ""
        self.jobPriceTextField.text = "$0.00"
        self.jobDetailsTextField.text = ""
    }
    
    //The next two functions configure the JobDateTextField to open a UIDatePicker and update the text as the UIDatePicker updates
    @IBAction func JobDateTextFieldSelected(_ textField: UITextField) {
        let todaysDate = Date()
        let datePicker = UIDatePicker()
        datePicker.minimumDate = todaysDate
        datePicker.datePickerMode = .date
        datePicker.maximumDate = todaysDate.addingTimeInterval(31536000) // a year from the current date
        datePicker.setDate(todaysDate, animated: true)
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        jobDateTextField.text = formatter.string(from: todaysDate)
        jobDateTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(datePickerChanged(sender:)), for: .valueChanged)
        
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        jobDateTextField.text = formatter.string(from: sender.date)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // The next three if statements test the textfields for text to verify that all fields have text in them each time the text field is changed. If any don't have text, the addJobButton is disabled
        
        if textField == jobTitleTextField
        {
            let oldStr = jobTitleTextField.text! as NSString
            let newStr = oldStr.replacingCharacters(in: range, with: string) as NSString
            if newStr.length == 0 || jobPriceTextField.text!.characters.count == 0 || jobDateTextField.text!.characters.count == 0{
                bottomAddJobButton.isEnabled = false
            }
            else {
                bottomAddJobButton.isEnabled = true
            }
        }
        if textField == jobPriceTextField
        {
            let oldStr = jobPriceTextField.text! as NSString
            let newStr = oldStr.replacingCharacters(in: range, with: string) as NSString
            if newStr.length == 0 || jobTitleTextField.text!.characters.count == 0 || jobDateTextField.text!.characters.count == 0{
                bottomAddJobButton.isEnabled = false
            }
            else {
                bottomAddJobButton.isEnabled = true
            }
        }
        if textField == jobDateTextField
        {
            let oldStr = jobPriceTextField.text! as NSString
            let newStr = oldStr.replacingCharacters(in: range, with: string) as NSString
            if newStr.length == 0 || jobTitleTextField.text!.characters.count == 0 || jobPriceTextField.text!.characters.count == 0 {
                bottomAddJobButton.isEnabled = false
            }
            else {
                bottomAddJobButton.isEnabled = true
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
