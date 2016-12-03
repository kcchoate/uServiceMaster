//
//  SelectedJobViewController.swift
//  uService
//

import UIKit

class SelectedJobViewController: UIViewController {

    
    @IBOutlet weak var locationTextView: UITextView!
    @IBOutlet weak var priceTextView: UITextView!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var jobDateTextView: UITextView!
    var locationText: String = ""
    var priceText: Float = 0
    var detailsText: String = ""
    var titleText: String = ""
    var dateText: String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //we create a number formatter to format the received price into a currency style. This prevents prices like $45.50 from appearing as $45.5
        let priceFormatter = NumberFormatter()
        priceFormatter.numberStyle = .currency
        priceFormatter.locale = Locale(identifier: "en_US")
        
        //The only way to reach this class is through a segue which sets the text info from the Table View. On load it just sets the info in a nice viewable format
        locationTextView.text! = locationText
        priceTextView.text! = priceFormatter.string(from: priceText as NSNumber)!
        detailsTextView.text! = detailsText
        jobDateTextView.text! = dateText
        self.title = titleText
        // Do any additional setup after loading the view.
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
