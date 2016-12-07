//
//  SelectedApplicationViewController.swift
//  uService
//
//  Created by Kendrick Choate on 12/4/16.
//  Copyright © 2016 Kendrick Choate. All rights reserved.
//

import UIKit
import MapKit
//TODO: - Add button to remove application from server. Will need to connect to server to do so.
class SelectedApplicationViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var paymentTextView: UITextView!
    @IBOutlet weak var postedTextView: UITextView!
    @IBOutlet weak var dueByTextView: UITextView!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var applicationMapView: MKMapView!
    
    let colorDarkGreen = UIColor(colorLiteralRed: 62/255, green: 137/255, blue: 20/255, alpha: 1)
    var selectedJob: Job? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = DateFormatter()
        applicationMapView.delegate = self
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let currencyFormatter = NumberFormatter()
        currencyFormatter.locale = Locale(identifier: "en-US")
        currencyFormatter.numberStyle = .currency
        
        dueByTextView.text! = dateFormatter.string(from: Date(timeIntervalSince1970: (selectedJob?.dueDate)!))
        paymentTextView.text! = currencyFormatter.string(from: NSNumber(value: (selectedJob?.pay)!))!
        postedTextView.text! = dateFormatter.string(from: Date(timeIntervalSince1970: (selectedJob?.date)!))
        detailsTextView.text! = (selectedJob?.description)!
        
        let regionRadius: CLLocationDistance = 50000.0
        let jobLat = (selectedJob?.latitude)!
        let jobLong = (selectedJob?.longitude)!
        let jobLocation = CLLocationCoordinate2D(latitude: jobLat, longitude: jobLong)
        let jobRegion = MKCoordinateRegionMakeWithDistance(jobLocation, regionRadius, regionRadius)
        let jobAnnotation = MKPointAnnotation()
        jobAnnotation.coordinate = jobLocation
        applicationMapView.addAnnotation(jobAnnotation)
        applicationMapView.setRegion(jobRegion, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKPinAnnotationView()
        annotationView.pinTintColor = colorDarkGreen
        return annotationView
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
