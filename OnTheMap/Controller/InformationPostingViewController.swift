//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Ahmed Tawfik on 10/11/17.
//  Copyright © 2017 Fox Apps. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class InformationPostingViewController: UIViewController {

    // MARK: IB Outlets
    @IBOutlet weak var mapString: UITextField!
    @IBOutlet weak var mediaURL: UITextField!
    @IBOutlet weak var findLocation: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Variables
    var placeMark: CLPlacemark?

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    // MARK: Configure the UI
    private func addTapGesture () {
        //Dismiss the keyboard in case the user click anywhere else in the screen
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // MARK: Keyboard/View Moving Methods
    @objc private func keyboardWillShow(_ notification: Notification) {
        if mapString.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification) / 1.2
        } else {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    private func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    private func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    private func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    
    // MARK: IB Actions
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocation(_ sender: UIButton) {
        dismissKeyboard()
        activityIndicator.startAnimating()
        let urlString = mediaURL.text!
        if mapString.text == "" {
            self.showAlert(Alerts.EmptyMapLocationTitle, message: Alerts.EmptyMapLocationMessage)
        } else if mediaURL.text == "" {
            self.showAlert(Alerts.EmptyURLTitle, message: Alerts.EmptyURLMessage)
        } else if !UIApplication.shared.canOpenURL(URL(string: urlString)!) {
            self.showAlert(Alerts.InvalidURLSchemeTitle, message: Alerts.InvalidURLSchemeMessage)
        }
        let geocoder = CLGeocoder()
        let location = mapString.text!

        geocoder.geocodeAddressString(location) { placemarks, error in
            if error != nil {
                self.showAlert(Alerts.InvalidMapStringTitle, message: Alerts.InvalidMapStringMessage)
            } else if let placemark = placemarks?[0] {
                self.placeMark = placemark
                UdacityClient.sharedInstance().udacityUserLocationInfo.mediaURL = self.mediaURL.text!
                UdacityClient.sharedInstance().udacityUserLocationInfo.mapString = self.mapString.text!
                self.performSegue(withIdentifier: "find Location Segue", sender: self)
            }
            self.activityIndicator.stopAnimating()
        }
    }
    
    // MARK: Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "find Location Segue" {
            let mapController = segue.destination as? AddLocationMapViewController
            mapController?.placeMark = placeMark
            mapController?.udacityUserLocationInfo = UdacityClient.sharedInstance().udacityUserLocationInfo
        }
    }
}

// MARK: ViewController extension - Text Field Delegate Methods
extension InformationPostingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == mapString {
            mediaURL.becomeFirstResponder()
        } else if textField == mediaURL {
            findLocation(findLocation)
        }
        textField.resignFirstResponder()
        return true
    }
}

