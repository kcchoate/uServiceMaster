//
//  JobApplicationViewController.swift
//  uService
//
//  Created by Tyler Allen on 11/23/16.
//  Copyright © 2016 Kendrick Choate. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class JobApplicationViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var dueByTextView: UITextView!
    @IBOutlet weak var paymentTextView: UITextView!
    @IBOutlet weak var jobDateTextView: UITextView!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var jobLocationMapView: MKMapView!
    var selectedJob: Job? = nil
    var loggedInUser: LoggedInUser? = nil
    let colorDarkGreen = UIColor(colorLiteralRed: 62/255, green: 137/255, blue: 20/255, alpha: 1)
    let amazonKey = "https://0944tu0fdb.execute-api.us-west-2.amazonaws.com/prod/applications"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jobLocationMapView.delegate = self
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let currencyFormatter = NumberFormatter()
        currencyFormatter.locale = Locale(identifier: "en-US")
        currencyFormatter.numberStyle = .currency
        dueByTextView.text! = dateFormatter.string(from: Date(timeIntervalSince1970: (selectedJob?.dueDate)!))
        paymentTextView.text! = currencyFormatter.string(from: NSNumber(value: (selectedJob?.pay)!))!
        jobDateTextView.text! = dateFormatter.string(from: Date(timeIntervalSince1970: (selectedJob?.date)!))
        detailsTextView.text! = (selectedJob?.description)!
        
        let regionRadius: CLLocationDistance = 50000.0
        let jobLat = (selectedJob?.latitude)!
        let jobLong = (selectedJob?.longitude)!
        let jobLocation = CLLocationCoordinate2D(latitude: jobLat, longitude: jobLong)
        let jobRegion = MKCoordinateRegionMakeWithDistance(jobLocation, regionRadius, regionRadius)
        let jobAnnotation = MKPointAnnotation()
        jobAnnotation.coordinate = jobLocation
        jobLocationMapView.addAnnotation(jobAnnotation)
        jobLocationMapView.setRegion(jobRegion, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func applyForJobPressed() {
        let newApplication = [
            "data": [
                "type": "applications",
                "attributes": [
                    "jid": (self.selectedJob?.jid)!,
                    "applicant": (self.loggedInUser?.uid)!,
                    "owner": (self.selectedJob?.owner)!
                ]
            ]
        ] as [String: Any]
        let jsonData = try! JSONSerialization.data(withJSONObject: newApplication, options: [.prettyPrinted])
        let requestURL: URL = URL(string: amazonKey)!
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                OperationQueue.main.addOperation {
                    self.presentErrorNotification(errorTitle: "Application not submitted.", errorMessage: (error?.localizedDescription)!)
                }
            } else {
                do {
                    guard let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] else { return }
                    
                    guard let errors = json?["errors"] as? [[String: Any]] else { return }
                    if errors.count > 0 {
                        OperationQueue.main.addOperation {
                            self.presentErrorNotification(errorTitle: "Application not submitted.", errorMessage: "Your job was not sent due to a network error.")
                        }
                        return
                    } else {
                        
                    }
                }
            }
        })
        task.resume()
        OperationQueue.main.addOperation {
            self.presentErrorNotification(errorTitle: "Successfully submitted application.", errorMessage: "Your application has been submitted.")
        }
    }
    
    //a utility function for presenting an error notification to the user
    func presentErrorNotification(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKPinAnnotationView()
        annotationView.pinTintColor = colorDarkGreen
        return annotationView
    }
    
}
