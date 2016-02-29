//
//  SecondViewController.swift
//  MoveContentUnderKeyboard
//
//  Created by Wesley Sadler on 2/25/16.
//  Copyright © 2016 Digital Sadler. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    struct SecondModel {
        var birdName: String
        var scientificName: String
        var birdImageFileName: String
        
        var locationBirdLastSeen: String?
        var locationBirdFirstSeen: String?
        var locationBirdSinging: String?
        
        init(aBirdName: String, aScientificName: String, aImageFileName: String) {
            birdName = aBirdName
            scientificName = aScientificName
            birdImageFileName = aImageFileName
        }
    }

    var secondModel: SecondModel?
    
    weak var activeTextField: UITextField?
    
    // Note: the background color of the scroll view is light grey to show the difference in size from content view
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var labelBirdName: UILabel!
    @IBOutlet weak var labelBirdScientificName: UILabel!
    @IBOutlet weak var imageBirdView: UIImageView!

    @IBOutlet weak var locationLastSeenTextField: UITextField!
    @IBOutlet weak var locationHeardTextField: UITextField!
    @IBOutlet weak var locationFirstSeenTextField: UITextField!
    
    // MARK: View Controller lifecycle methods
    
    deinit {
        self.deregisterFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.registerForKeyboardNotifications()
        
        secondModel = SecondModel(aBirdName: "House Wren", aScientificName: "Troglodytes-aedon", aImageFileName: "Troglodytes-aedon.png")
        
        imageBirdView.image = UIImage(named: (secondModel?.birdImageFileName)!)
        
        labelBirdName.text = secondModel?.birdName
        labelBirdName.textAlignment = .Center
        labelBirdName.font = .boldSystemFontOfSize(22.0)
        labelBirdName.adjustsFontSizeToFitWidth = true
        
        labelBirdScientificName.text = secondModel?.scientificName
        labelBirdScientificName.textAlignment = .Center
        labelBirdScientificName.font = .boldSystemFontOfSize(17.0)
        labelBirdScientificName.adjustsFontSizeToFitWidth = true
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Keyboard Notifications for keyboard
    
    func registerForKeyboardNotifications() {
        // Adding notifies on keyboard show and hide
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func deregisterFromKeyboardNotifications() {
        // Removing notifies on keyboard show and hide
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // Called when the UIKeyboardDidShowNotification is sent
    func keyboardWasShown(notification: NSNotification) {

        if let activeField = self.activeTextField, keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size {

            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            var aRect = self.view.frame
            aRect.size.height -= keyboardSize.height
            
            // active text field is hidden by keyboard, scroll text field so it's visible
            if (!CGRectContainsPoint(aRect, activeField.frame.origin)) {
                var bkgndRect = activeField.superview?.frame
                bkgndRect?.size.height += keyboardSize.height
                activeField.superview?.frame = bkgndRect!
                scrollView.setContentOffset(CGPointMake(0.0, activeField.frame.origin.y - keyboardSize.height), animated: true)
            }
        }
        
    }
    
    // Called when the UIKeyboardWillHideNotification is sent
    func keyboardWillBeHidden(notification: NSNotification) {
        // Restore view too original position
        let contentInsets = UIEdgeInsetsZero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeTextField = nil
        
        switch textField {
            
        case locationLastSeenTextField:
            
            secondModel?.locationBirdLastSeen = textField.text
            
        case locationHeardTextField:
            
            secondModel?.locationBirdSinging = textField.text
            
        case locationFirstSeenTextField:
            
            secondModel?.locationBirdFirstSeen = textField.text
            
        default: break
            
        }
    }
    
    // Hide the keyboard when the user taps the "Return" key or its equivalent
    // while editing a text field.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }

}

