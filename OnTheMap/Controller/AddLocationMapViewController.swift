//
//  AddLocationMapViewController.swift
//  OnTheMap
//
//  Created by Ahmed Tawfik on 10/11/17.
//  Copyright © 2017 Fox Apps. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddLocationMapViewController: UIViewController {

    // MARK: IB Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Variables
    var placeMark: CLPlacemark?
    var udacityUserLocationInfo = UdacityUser()

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        openMapForPlace(placeMark!)
    }

    // MARK: IB Actoins
    @IBAction func submitLocation(_ sender: UIButton) {
        ParseClient.sharedInstance().submitStudentLocation(udacitUserLocationInfo: udacityUserLocationInfo, placeMark: placeMark!) { (success, errorString) in
            DispatchQueue.main.async {
                if success {
                    print("Submit Location Successful")
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print("Submit Location Unsuccessful")
                    self.showAlert(Alerts.SubmitLocationFailedTitle, message: Alerts.SubmitLocationFailedMessage)
                }
            }
        }
    }
    
    // MARK: Helper Functions
    func openMapForPlace(_ placeMark: CLPlacemark) {
        let coardinates = (placeMark.location?.coordinate)!
        let span = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(0.1), longitudeDelta: CLLocationDegrees(0.1))
        let region = MKCoordinateRegion(center: coardinates, span: span)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coardinates
        annotation.title = placeMark.name
        mapView.addAnnotation(annotation)
        mapView.setRegion(region, animated: true)
    }
}

// MARK: MKMapViewDelegate extension
extension AddLocationMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
}
