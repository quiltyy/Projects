//
//  ViewController.swift
//  ChoreGold
//
//  Created by Andrew Chamberlain on 12/17/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Outlets
    @IBOutlet weak var textEntryField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    // Data source for the table
    var tableData: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set delegate and dataSource
        tableView.delegate = self
        tableView.dataSource = self
    }

    // Button action
    @IBAction func addButtonTapped(_ sender: UIButton) {
        // Ensure text is not empty
        guard let text = textEntryField.text, !text.isEmpty else { return }
        // Add text to the data source
        tableData.append(text)
        // Clear the text field
        textEntryField.text = ""
        // Reload table view
        tableView.reloadData()
    }

    // MARK: - Table View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = tableData[indexPath.row]
        return cell
    }
}

