//
//  FirstDetailView.swift
//  MoveContentUnderKeyboard
//
//  Created by Wesley Sadler on 2/25/16.
//  Copyright © 2016 Digital Sadler. All rights reserved.
//

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
    var birdNameLabelTextColor: UIColor { return .blackColor() }
    var birdNameLabelFont: UIFont { return .boldSystemFontOfSize(22.0) }
    var birdNameLabelTextAlignment: NSTextAlignment { return .Center }
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
    var scientificNameLabelTextColor: UIColor { return .blackColor() }
    var scientificNameLabelFont: UIFont { return .boldSystemFontOfSize(17.0) }
    var scientificNameLabelTextAlignment: NSTextAlignment { return .Center }
    var scientificNameLabelAdjustsFontSize: Bool { return true }
    
}

// Has Bird Seen Switch Protocol
protocol HasSeenBirdSwitchPresentable {
    var switchOn: Bool { get }
    var switchColor: UIColor { get }
    
    mutating func switchToggleOn(on: Bool)
}

extension HasSeenBirdSwitchPresentable {
    var switchColor: UIColor { return .blueColor() }
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
typealias FirstViewPresentable = protocol<BirdNameLabelPresentable, ScientificNameLabelPresentable, HasSeenBirdSwitchPresentable, ImagePresentable, NumberBirdsTextFieldPresentable, LocationBirdsTextFieldPresentable, DescriptionBirdsTextFieldPresentable>

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
        
        
        switchToggle.on = presenter.switchOn
        switchToggle.onTintColor = presenter.switchColor
        
        enableDisableTextFields(presenter.switchOn)
        
        imageBirdView.image = UIImage(named: presenter.birdImageName)
        
    }
    
    @IBAction func onSwitchToggle(sender: UISwitch) {
        delegate?.switchToggleOn(sender.on)
        enableDisableTextFields(sender.on)
    }
    
    // Called when the UIKeyboardDidShowNotification is sent
    func keyboardWasShown(notification: NSNotification) {
        
        if let activeField = self.activeTextField, keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size {
            // this is the scroll view that contains this view
            let viewSuperView = self.superview
            if let unwrappedScrollView = viewSuperView {
                if unwrappedScrollView is UIScrollView {
                    let scrollView = unwrappedScrollView as! UIScrollView
                    // this is the view controllers view
                    let scrollViewSuperView = scrollView.superview
                    if let unwrappedScrollViewSuperView = scrollViewSuperView {
                        
                        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
                        scrollView.contentInset = contentInsets
                        scrollView.scrollIndicatorInsets = contentInsets
                        
                        var aRect : CGRect = unwrappedScrollViewSuperView.frame
                        aRect.size.height -= keyboardSize.height
                        // active text field is hidden by keyboard, scroll text field so it's visible
                        if (!CGRectContainsPoint(aRect, activeField.frame.origin)) {
                            scrollView.scrollRectToVisible(activeField.frame, animated: true)
                        }
                    }
                }
            }
        }
        
    }
    
    // Called when the UIKeyboardWillHideNotification is sent
    func keyboardWillBeHidden(notification: NSNotification) {
        let viewSuperView = self.superview
        if let unwrappedScrollView = viewSuperView {
            if unwrappedScrollView is UIScrollView {
                let scrollView = unwrappedScrollView as! UIScrollView
                // Restore view too original position
                let contentInsets = UIEdgeInsetsZero
                scrollView.contentInset = contentInsets
                scrollView.scrollIndicatorInsets = contentInsets
            }
        }
    }

    // MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeTextField = nil
        
        switch textField {

        case numberBirdsTextField:
            
            if let unwrappedNumberBirds = textField.text {
                if !unwrappedNumberBirds.isEmpty {
                    // Don't have to check conversion to int because only numbers allow in text field
                    delegate?.onNumberBirdsTextFieldDidEndEditing(Int(unwrappedNumberBirds)!)
                }
            }
        case descriptionBirdsTextField:
            
            if let unwrappedDescriptionBirds = textField.text {
                delegate?.onDescriptionBirdsTextFieldDidEndEditing(unwrappedDescriptionBirds)
            }
        case locationBirdsTextField:
            
            if let unwrappedLocationBirds = textField.text {
                delegate?.onLocationBirdsTextFieldDidEndEditing(unwrappedLocationBirds)
            }            
        default: break
            
        }
    }
    
    // Hide the keyboard when the user taps the "Return" key or its equivalent
    // while editing a text field.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
            // Allow only numbers in this field
        case numberBirdsTextField:
            
            let inverseSet = NSCharacterSet(charactersInString:"0123456789").invertedSet
            let components = string.componentsSeparatedByCharactersInSet(inverseSet)
            let filtered = components.joinWithSeparator("")
            
            return string == filtered
            
            // Do not put constraints on any other text field in this view
            // that uses this class as its delegate.
        default:
            return true
        }
    }

    // Disable text fields when bird has not been seen
    private func enableDisableTextFields(on: Bool) {

        numberBirdsTextField.enabled = on
        locationBirdsTextField.enabled = on
        descriptionBirdsTextField.enabled = on
        
    }
    
}
