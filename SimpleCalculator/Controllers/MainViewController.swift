//
//  ViewController.swift
//  SimpleCalculator
//
//  Created by Admin on 07.02.2022.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet var displayLabel: UILabel!
    
    private var calculator = CalculatorLogic()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func calcButtonPressed(_ sender: UIButton) {
        displayLabel.text = calculator.calcButtonPressed(value: sender.currentTitle)
    }
    
    @IBAction func numButtonPressed(_ sender: UIButton) {
        displayLabel.text = calculator.numButtonPressed(value: sender.currentTitle)
    }
}

