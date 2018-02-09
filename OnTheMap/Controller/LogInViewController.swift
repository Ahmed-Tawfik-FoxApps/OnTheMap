//
//  LogInViewController.swift
//  OnTheMap
//
//  Created by Ahmed Tawfik on 10/8/17.
//  Copyright © 2017 Fox Apps. All rights reserved.
//

import UIKit
import SafariServices
import SystemConfiguration

class LogInViewController: UIViewController {
    
    // MARK: IB Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Variables
    var downloadDataFromParseFailed = false
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        emailTextField.text = ""
        passwordTextField.text = ""
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
        if emailTextField.isFirstResponder {
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
    @IBAction func loginPressed(_ sender: UIButton) {
        print("Login Pressed")
        loginInProgress()
        if loginVerification() {
            UdacityClient.sharedInstance().loginWithEmailAndPassword(email: emailTextField.text!, password: passwordTextField.text!, completionHandlerForLogIn: { (success, errorString) in
                DispatchQueue.main.async {
                    if success {
                        print("Login Sucssesful")
                        self.performSegue(withIdentifier: "login Segue", sender: self)
                    } else {
                        print("Login Unsucssesful")
                            self.showAlert(Alerts.LoginFailedTitle, message: Alerts.LoginFailedMessage)
                    }
                    self.loginCompleted()
                }
            })
        } else {
            self.loginCompleted()
        }
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        let sigUpURL = URL(string: "https://www.udacity.com/account/auth#!/signup")
        UIApplication.shared.open(sigUpURL!, options: [:], completionHandler: nil)
    }
    
    // MARK: Helper Functions
    func loginVerification () -> Bool {
        if emailTextField.text == "" || passwordTextField.text == "" {
            self.showAlert(Alerts.LoginFailedTitle, message: Alerts.CredintialsIsEmptyMessage)
            return false
        } else if !checkNetworkConnectivity() {
            self.showAlert(Alerts.NoConnectionTitle, message: Alerts.NoConnectionMessage)
            return false
        } else {
            return true
        }
    }
    
    func loginInProgress () {
        dismissKeyboard()
        activityIndicator.startAnimating()
        loginButton.isEnabled = false
    }
    
    func loginCompleted () {
        activityIndicator.stopAnimating()
        loginButton.isEnabled = true
    }
}

// MARK: ViewController extension - Text Field Delegate Methods
extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            loginPressed(loginButton)
        }
        textField.resignFirstResponder()
        return true
    }
}

// MARK: ViewController extension 
extension UIViewController {
    func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Alerts.DismissAlert, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func openURLinSafari (url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            let svc = SFSafariViewController(url: url)
            present(svc, animated: true, completion: nil)
        } else {
            showAlert(Alerts.InvalidURLSchemeTitle, message: Alerts.InvalidURLSchemeMessage)
        }
    }
    
    func checkNetworkConnectivity () -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection)
    }
    
}
