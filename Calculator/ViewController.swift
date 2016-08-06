//
//  ViewController.swift
//  Calculator
//
//  Created by 준호 김 on 2016. 7. 8..
//  Copyright © 2016년 JunhoKim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var display: UILabel!
    @IBOutlet private weak var descriptionBar: UILabel!
    @IBOutlet private weak var floatingPointBtn: UIButton!
    
    private var userIsInTheMiddleOfTyping = false
    
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        print(digit)
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            let result = textCurrentlyInDisplay.rangeOfString(".")
            if result == nil {
                floatingPointBtn.enabled = true
            } else{
                floatingPointBtn.enabled = false
            }
            display.text = textCurrentlyInDisplay + digit
            descriptionBar.text = brain.description
            //print(display.text)
        } else{
            display.text = digit
            descriptionBar.text = brain.description
            floatingPointBtn.enabled = true
        }
        userIsInTheMiddleOfTyping = true
    }
    
    private var displayValue: Double {
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    
    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle{
            brain.performOperation(mathematicalSymbol)
            descriptionBar.text = brain.description
        }
        displayValue = brain.result
    }

}

