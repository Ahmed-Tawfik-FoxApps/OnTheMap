//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Ahmed Tawfik on 10/10/17.
//  Copyright © 2017 Fox Apps. All rights reserved.
//

import UIKit

class TableViewController: MapTableSuperClassViewController {
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: TableViewController extension - Table Delegate Methods and Data Source
extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentInformations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentInformationCell", for: indexPath)
        let name = "\(studentInformations[indexPath.row].firstName) \(studentInformations[indexPath.row].lastName)"
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = studentInformations[indexPath.row].mediaURL
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if studentInformations[indexPath.row].mediaURL == "" {
            showAlert(Alerts.EmptyURLTitle, message: Alerts.EmptyURLMessage)
        }
        if let url = URL(string: studentInformations[indexPath.row].mediaURL) {
            openURLinSafari(url: url)
        }
    }
}
