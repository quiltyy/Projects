//
//  ViewController.swift
//  ChoreGold
//
//  Created by Andrew Chamberlain on 12/11/24.
//

import UIKit

class ViewController: UIViewController {
    // Outlets
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var stepper: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the initial values for the label and stepper
        counterLabel.text = "0"
        stepper.value = 0
        stepper.minimumValue = 0 // Optional to prevent negative values
    }
    // IBAction for the stepper
    @IBAction func pressStepper(_ sender: Any) {
        // Update the label with the current value of the stepper
        counterLabel.text = String(Int(stepper.value))
        
    }
    @IBAction func continuePressed(_ sender: Any) {
    }
    
}

