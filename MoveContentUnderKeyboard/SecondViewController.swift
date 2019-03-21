//
//  SecondViewController.swift
//  MoveContentUnderKeyboard
//
//  Created by Wesley Sadler on 2/25/16.
//  Copyright © 2016 Digital Sadler. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    // MARK: Properties
    
    private var notificationTokens = [NotificationToken]()
    
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
    
    var activeTextField: UITextField?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        secondModel = SecondModel(aBirdName: "House Wren", aScientificName: "Troglodytes-aedon", aImageFileName: "Troglodytes-aedon.png")
        
        imageBirdView.image = UIImage(named: (secondModel?.birdImageFileName)!)
        
        labelBirdName.text = secondModel?.birdName
        labelBirdName.textAlignment = .center
        labelBirdName.font = .boldSystemFont(ofSize: 22.0)
        labelBirdName.adjustsFontSizeToFitWidth = true
        
        labelBirdScientificName.text = secondModel?.scientificName
        labelBirdScientificName.textAlignment = .center
        labelBirdScientificName.font = .boldSystemFont(ofSize: 17.0)
        labelBirdScientificName.adjustsFontSizeToFitWidth = true
        
        // OPTION 1
//        scrollView.keyboardDismissMode = .onDrag

        // OPTION 2
//        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(sender:)))
//        view.addGestureRecognizer(tap)
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unregisterKeyboardNotifications()
    }

    // MARK: - Gesture Actions
    @objc func dismissKeyboard(sender: UITapGestureRecognizer) {
        guard let active = activeTextField else { return }
        
        active.resignFirstResponder()
    }

    // MARK: Keyboard Notifications for keyboard
    
    func registerKeyboardNotifications() {
        let center = NotificationCenter.default
        
        let keyboardWillShowToken = center.addObserver(forDescriptor: UIViewController.keyboardWillShow) { (payload) in
            let contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: payload.endFrame.height, right: 0.0)
            self.scrollView.contentInset = contentInset
            self.scrollView.scrollIndicatorInsets = contentInset
            
            var visibleFrame = self.scrollView.frame
            visibleFrame = CGRect(x: visibleFrame.minX, y: visibleFrame.minY, width: visibleFrame.width, height: visibleFrame.height - payload.endFrame.height)
            
            guard let active = self.activeTextField else {
                return
            }
            guard !visibleFrame.contains(active.frame.origin) else { return }

            var bkgndRect = active.superview?.frame
            bkgndRect?.size.height += payload.endFrame.height
            active.superview?.frame = bkgndRect!
            self.scrollView.setContentOffset(CGPoint(x: 0.0, y: active.frame.origin.y - payload.endFrame.height), animated: true)
        }
        
        notificationTokens.append(keyboardWillShowToken)
        
        let keyboardWillHideToken = center.addObserver(forDescriptor: UIViewController.keyboardWillHide) { _ in
            let contentInset = UIEdgeInsets.zero
            self.scrollView.contentInset = contentInset
            self.scrollView.scrollIndicatorInsets = contentInset
        }
        notificationTokens.append(keyboardWillHideToken)
    }
    
    func unregisterKeyboardNotifications() {
        notificationTokens.removeAll()
    }
    
    // Called when the UIKeyboardDidShowNotification is sent
    @objc func keyboardWasShown(notification: NSNotification) {

        if let activeField = self.activeTextField, let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size {

            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            var aRect = self.view.frame
            aRect.size.height -= keyboardSize.height
            
            // active text field is hidden by keyboard, scroll text field so it's visible
            if (!aRect.contains(activeField.frame.origin)) {
                var bkgndRect = activeField.superview?.frame
                bkgndRect?.size.height += keyboardSize.height
                activeField.superview?.frame = bkgndRect!
                scrollView.setContentOffset(CGPoint(x: 0.0, y: activeField.frame.origin.y - keyboardSize.height), animated: true)
            }
        }
        
    }
    
    // Called when the UIKeyboardWillHideNotification is sent
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        // Restore view too original position
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
}

// MARK: UITextFieldDelegate

extension SecondViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if activeTextField === textField {
            activeTextField = nil
        }
        
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
    // OPTION 3
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if activeTextField === textField {
            activeTextField?.resignFirstResponder()
        }
        return true
    }
}

