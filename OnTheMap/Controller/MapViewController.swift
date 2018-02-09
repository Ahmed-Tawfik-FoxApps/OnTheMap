//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Ahmed Tawfik on 10/7/17.
//  Copyright © 2017 Fox Apps. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: MapTableSuperClassViewController {

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }    
}

// MARK: MapViewController extension - Map Delegate Methods
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
                
        return pinView

    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let urlString = view.annotation?.subtitle!
            if urlString == "" {
                showAlert(Alerts.EmptyURLTitle, message: Alerts.EmptyURLMessage)
            } else if let url = URL(string: urlString!) {
                openURLinSafari(url: url)
            }
        }
    }
}

