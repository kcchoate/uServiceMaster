//
//  SearchScreenViewController.swift
//  uService
//
//  Created by Kendrick Choate on 11/3/16.
//  Copyright © 2016 Kendrick Choate. All rights reserved.
//

import UIKit
import MapKit

class SearchScreenViewController: UIViewController, MKMapViewDelegate {
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
//    var currentPin = MKAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        self.mapView.delegate = self
        var currentLocation = CLLocation()
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            locationManager.startUpdatingLocation()
            currentLocation = locationManager.location!
            
        }
        let regionRadius: CLLocationDistance = 5000.0
        let region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, regionRadius, regionRadius)
        mapView.setRegion(region, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKPinAnnotationView()
        annotationView.canShowCallout = true
        annotationView.pinTintColor = UIColor.green
        annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
 //       currentPin = view.annotation! as! MKPointAnnotation
        performSegue(withIdentifier: "detailsDisclosurePressed", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsDisclosurePressed" {
            let applicantVC = segue.destination as! JobApplicationViewController
            let backitem = UIBarButtonItem()
            backitem.title = "Back"
            navigationItem.backBarButtonItem = backitem
 //           applicantVC.title = currentPin.title
        }
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

extension SearchScreenViewController: CLLocationManagerDelegate {
    
}
