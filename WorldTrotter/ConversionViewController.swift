//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Tyler Percy on 2/4/19.
//  Copyright © 2019 Tyler Percy. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
    
    //format decimals in conversion
    //This is called in the function that does the conversion
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0 //allow whole numbers
        nf.maximumFractionDigits = 1 //round to the nearest tenth
        return nf
    }()
    
    @IBOutlet var celsiusLabel: UILabel!
    var fahrenheitValue: Measurement<UnitTemperature>? {
        didSet {
            updateCelsiusLabel()
        }
    }
    
    //celsius label displays converted value
    func updateCelsiusLabel() {
        if let celsiusValue = celsiusValue {
            celsiusLabel.text =
                numberFormatter.string(from: NSNumber(value: celsiusValue.value))
        } else {
            celsiusLabel.text = "???" //filler text if no conversion is taking place
        }
    }
    
    //Helper function to do the conversion
    var celsiusValue: Measurement<UnitTemperature>? {
        if let fahrenheitValue = fahrenheitValue {
            return fahrenheitValue.converted(to: .celsius)
        } else {
            return nil
        }
    }
    
    @IBOutlet var textField: UITextField!
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let existingTextHasDecimalSeperator = textField.text?.range(of: ".")
        let replacementTextHasDecimalSeperator = string.range(of: ".")
        
        //only allow 0-9, backspace, and period (A+ LEVEL)
        guard CharacterSet(charactersIn: ".0123456789\\b").isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        
        if existingTextHasDecimalSeperator != nil,
            replacementTextHasDecimalSeperator != nil {
            return false
        } else {
            return true
        }
    }
    
    //Helper function to update fahrenheit text field
    @IBAction func fahrenheitFieldEditingChanged(_ textField: UITextField) {
        if let text = textField.text, let value = Double(text) {
            fahrenheitValue = Measurement(value: value, unit: .fahrenheit)
        } else {
            fahrenheitValue = nil
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
    
    @IBOutlet var backgroundView: UIView!
    
    //initial call when application starts
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ConversionViewController loaded its view.")
        
        /* Chapter 5 Silver */
        
        let darkColor = UIColor(red: 51/255, green: 52/255, blue: 50/255, alpha: 1.0)
        let greyColor = UIColor(red: 238/255, green: 240/255, blue: 239/255, alpha: 1.0)
        let hour = NSCalendar.current.component(.hour, from: NSDate() as Date)
        
        //coloring the background
        //number ranges here represent time of day in hours
        switch hour {
        case 1...6:
            self.backgroundView.backgroundColor = darkColor
        case 7...18:
            self.backgroundView.backgroundColor = greyColor
        case 19...23, 0:
            self.backgroundView.backgroundColor = darkColor
        default:
            //This should never happen
            self.backgroundView.backgroundColor = greyColor
        }
        
        updateCelsiusLabel() //shows default values for fahrenheit and celsius
    }
}
