//
//  FirstDetailView.swift
//  MoveContentUnderKeyboard
//
//  Created by Wesley Sadler on 2/25/16.
//
//  The MIT License
//
//  Copyright © 2016 - 2019 Digital Sadler.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  opies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


import UIKit

// Bird Name Label Protocol
protocol BirdNameLabelPresentable {
    var birdNameLabelText: String { get }
    var birdNameLabelTextColor: UIColor { get }
    var birdNameLabelFont: UIFont { get }
    var birdNameLabelTextAlignment: NSTextAlignment { get }
    var birdNameLabelAdjustsFontSize: Bool { get }
}

extension BirdNameLabelPresentable {
    var birdNameLabelTextColor: UIColor { return .black }
    var birdNameLabelFont: UIFont { return .boldSystemFont(ofSize: 22.0) }
    var birdNameLabelTextAlignment: NSTextAlignment { return .center }
    var birdNameLabelAdjustsFontSize: Bool { return true }
}

// Scientific Name Label Protocol
protocol ScientificNameLabelPresentable {
    var scientificNameLabelText: String { get }
    var scientificNameLabelTextColor: UIColor { get }
    var scientificNameLabelFont: UIFont { get }
    var scientificNameLabelTextAlignment: NSTextAlignment { get }
    var scientificNameLabelAdjustsFontSize: Bool { get }
}

extension ScientificNameLabelPresentable {
    var scientificNameLabelTextColor: UIColor { return .black }
    var scientificNameLabelFont: UIFont { return .boldSystemFont(ofSize: 17.0) }
    var scientificNameLabelTextAlignment: NSTextAlignment { return .center }
    var scientificNameLabelAdjustsFontSize: Bool { return true }
}

// Has Bird Seen Switch Protocol
protocol HasSeenBirdSwitchPresentable {
    var switchOn: Bool { get }
    var switchColor: UIColor { get }
    
    mutating func switchToggleOn(on: Bool)
}

extension HasSeenBirdSwitchPresentable {
    var switchColor: UIColor { return .blue }
}

// Bird Image Protocol
protocol ImagePresentable {
    var birdImageName: String { get }
}

extension ImagePresentable {
    var birdImageName: String { return "question.png" }
}

// Number Birds Protocol
protocol NumberBirdsTextFieldPresentable {
    var numberBirdsText: Int { get }
    
    mutating func onNumberBirdsTextFieldDidEndEditing(textField: Int)
}

// Location Birds Protocol
protocol LocationBirdsTextFieldPresentable {
    var locationBirdsText: String { get }
    
    mutating func onLocationBirdsTextFieldDidEndEditing(textField: String)
}

// Description Birds Protocol
protocol DescriptionBirdsTextFieldPresentable {
    var descriptionBirdsText: String { get }
    
    mutating func onDescriptionBirdsTextFieldDidEndEditing(textField: String)
}


// protocol composition
// based on the UI components in the view
typealias FirstViewPresentable = BirdNameLabelPresentable & ScientificNameLabelPresentable & HasSeenBirdSwitchPresentable & ImagePresentable & NumberBirdsTextFieldPresentable & LocationBirdsTextFieldPresentable & DescriptionBirdsTextFieldPresentable

class FirstDetailView: UIView, UITextFieldDelegate {

    weak var activeTextField: UITextField?

    @IBOutlet weak var labelBirdName: UILabel!
    @IBOutlet weak var labelBirdScientificName: UILabel!
    @IBOutlet weak var switchToggle: UISwitch!
    @IBOutlet weak var imageBirdView: UIImageView!
    @IBOutlet weak var numberBirdsTextField: UITextField!
    @IBOutlet weak var locationBirdsTextField: UITextField!
    @IBOutlet weak var descriptionBirdsTextField: UITextField!
    
    @IBOutlet weak var labelSpacer: UILabel!
    
    private var delegate: FirstViewPresentable?
    
    // configure with something that conforms to the composed protocol
    func configure(withPresenter presenter: FirstViewPresentable) {
        delegate = presenter
        
        // remove text from spacer label
        labelSpacer.text = ""
        // configure the UI components
        labelBirdName.text = presenter.birdNameLabelText
        labelBirdName.textColor = presenter.birdNameLabelTextColor
        labelBirdName.font = presenter.birdNameLabelFont
        labelBirdName.textAlignment = presenter.birdNameLabelTextAlignment
        labelBirdName.adjustsFontSizeToFitWidth = presenter.birdNameLabelAdjustsFontSize
        
        labelBirdScientificName.text = presenter.scientificNameLabelText
        labelBirdScientificName.textColor = presenter.scientificNameLabelTextColor
        labelBirdScientificName.font = presenter.scientificNameLabelFont
        labelBirdScientificName.textAlignment = presenter.scientificNameLabelTextAlignment
        labelBirdScientificName.adjustsFontSizeToFitWidth = presenter.scientificNameLabelAdjustsFontSize
        
        
        switchToggle.isOn = presenter.switchOn
        switchToggle.onTintColor = presenter.switchColor
        
        enableDisableTextFields(on: presenter.switchOn)
        
        imageBirdView.image = UIImage(named: presenter.birdImageName)
        
    }
    
    @IBAction func onSwitchToggle(sender: UISwitch) {
        delegate?.switchToggleOn(on: sender.isOn)
        enableDisableTextFields(on: sender.isOn)
    }

    
    // MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
        
        switch textField {

        case numberBirdsTextField:
            
            if let unwrappedNumberBirds = textField.text {
                if !unwrappedNumberBirds.isEmpty {
                    // Don't have to check conversion to int because only numbers allow in text field
                    delegate?.onNumberBirdsTextFieldDidEndEditing(textField: Int(unwrappedNumberBirds)!)
                }
            }
        case descriptionBirdsTextField:
            
            if let unwrappedDescriptionBirds = textField.text {
                delegate?.onDescriptionBirdsTextFieldDidEndEditing(textField: unwrappedDescriptionBirds)
            }
        case locationBirdsTextField:
            
            if let unwrappedLocationBirds = textField.text {
                delegate?.onLocationBirdsTextFieldDidEndEditing(textField: unwrappedLocationBirds)
            }            
        default: break
            
        }
    }
    
    // Hide the keyboard when the user taps the "Return" key or its equivalent
    // while editing a text field.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
            // Allow only numbers in this field
        case numberBirdsTextField:
            
            let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")
            
            return string == filtered
            
            // Do not put constraints on any other text field in this view
            // that uses this class as its delegate.
        default:
            return true
        }
    }

    // Disable text fields when bird has not been seen
    private func enableDisableTextFields(on: Bool) {

        numberBirdsTextField.isEnabled = on
        locationBirdsTextField.isEnabled = on
        descriptionBirdsTextField.isEnabled = on
    }
}
