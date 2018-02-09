//
//  MapTableSuperClassViewController.swift
//  OnTheMap
//
//  Created by Ahmed Tawfik on 10/12/17.
//  Copyright © 2017 Fox Apps. All rights reserved.
//

import UIKit
import MapKit

class MapTableSuperClassViewController: UIViewController {

    // MARK: IB Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: Variables
    var studentInformations : [StudentInformation] {
        get {
            return StudentInformationModel.sharedInstance().studentInformation
        }
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadStudenInformationsAndRefresh(self)
    }
    
    // MARK: IB Actions
    @IBAction func logout(_ sender: UIBarButtonItem) {
        activityIndicator.startAnimating()
        UdacityClient.sharedInstance().deleteSession { (success, errorString) in
            DispatchQueue.main.async {
                if success {
                    print("Logout Successful")
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print("Logout Unsuccessful")
                    self.showAlert(Alerts.LogoutFailedTitle, message: Alerts.LogoutFailedMessage)
                }
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    @IBAction func loadStudenInformationsAndRefresh(_ sender: Any) {
        activityIndicator.startAnimating()
        ParseClient.sharedInstance().getStudentInformation { (success, errorString) in
            DispatchQueue.main.async {
                if success {
                    print("Refresh Sucssesful")
                    self.reloadViews()
                } else {
                    print("Refresh Unsucssesful")
                    self.showAlert(Alerts.DownloadParseDataFailedTitle, message: Alerts.DownloadParseDataFailedMessage)
                }
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    @IBAction func addLocation(_ sender: UIBarButtonItem) {
        activityIndicator.startAnimating()
        ParseClient.sharedInstance().userHasRecordInDB { (success, userHasRecord, errorString) in
            UdacityClient.sharedInstance().udacityUserLocationInfo.userHasRecord = userHasRecord
            DispatchQueue.main.async {
                if success {
                    if !userHasRecord {
                        self.performSegue(withIdentifier: "addLocation Segue", sender: self)
                    } else {
                        let alert = UIAlertController(title: Alerts.OverwriteLocationTitle, message: Alerts.OverwriteLocationMessage, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: Alerts.OverwriteAlert, style: .default, handler: { (overwrite) in
                            self.performSegue(withIdentifier: "addLocation Segue", sender: self)
                        }))
                        alert.addAction(UIAlertAction(title: Alerts.CancelAlert, style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                } else {
                    self.showAlert(Alerts.CouldnotVerifyUserTitle, message: Alerts.CouldnotVerifyUserMessage)
                }
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    // MARK: Helper Functions
    func addAnnotations() {
        var annotations = [MKPointAnnotation]()
        for studentInformation in studentInformations {
            let lat = CLLocationDegrees(studentInformation.latitude)
            let long = CLLocationDegrees(studentInformation.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(studentInformation.firstName) \(studentInformation.lastName)"
            annotation.subtitle = studentInformation.mediaURL
            
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
    }
    
    func reloadViews () {
        if tableView != nil {
            tableView.reloadData()
        }
        if mapView != nil {
            refreshMapAnnotations()
        }
    }
    
    func refreshMapAnnotations () {
        let oldAnnotations = mapView.annotations
        mapView.removeAnnotations(oldAnnotations)
        addAnnotations()
    }
}
