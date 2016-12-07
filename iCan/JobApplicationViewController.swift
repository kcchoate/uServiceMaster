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
    let colorDarkGreen = UIColor(colorLiteralRed: 62/255, green: 137/255, blue: 20/255, alpha: 1)
    
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
        //TODO: - Send application to job to server 
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKPinAnnotationView()
        annotationView.pinTintColor = colorDarkGreen
        return annotationView
    }
    
}
