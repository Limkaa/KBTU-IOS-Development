//
//  ViewController.swift
//  Calculator Task
//
//  Created by Alim on 01.02.2021.
//

import UIKit

class ViewController: UIViewController {

    var typing: Bool = false
    var hasDelimiter: Bool = false
    
    @IBOutlet weak var myDisplay: UILabel!
    
    @IBAction func symbolPressed(_ sender: UIButton) {
        let current_symbol = sender.currentTitle!
        let current_display = myDisplay.text!
        
        if typing{
            if (current_symbol == ".") {
                if (!hasDelimiter) {
                    myDisplay.text = current_display + current_symbol
                    hasDelimiter = true
                }
            } else {
                myDisplay.text = current_display + current_symbol
            }
        } else {
            if (current_symbol != ".") {
                myDisplay.text = current_symbol
                typing = true
            }
        }
    }
    
    var displayValue: Double {
        get {
            return Double(myDisplay.text!)!
        }
        set {
            myDisplay.text = String(newValue)
        }
    }
    
    private var calculatorModel = CalculatorModel()
    @IBAction func operationPressed(_ sender: UIButton) {
        calculatorModel.setOperand(displayValue)
        calculatorModel.performOperation(sender.currentTitle!)
        displayValue = calculatorModel.getResult()!
        typing = false
        hasDelimiter = false
    }
}

