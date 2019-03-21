//
//  FirstViewController.swift
//  MoveContentUnderKeyboard
//
//  Created by Wesley Sadler on 2/25/16.
//  Copyright © 2016 Digital Sadler. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    // Note: the background color of the scroll view is light grey to show the difference in size from detail view
    @IBOutlet weak var detailView: FirstDetailView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: Properties
    
    private var notificationTokens = [NotificationToken]()

    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstViewModel = FirstViewModel(birdName: "American Robin", scientificName: "Turdus-migratorius", birdImageFileName: "Turdus-migratorius.png")
        
        detailView.configure(withPresenter: firstViewModel)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        registerKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unregisterKeyboardNotifications()
    }

    
    // MARK: Keyboard Notifications
    
    func registerKeyboardNotifications() {
        let center = NotificationCenter.default
        
        let keyboardWillShowToken = center.addObserver(forDescriptor: UIViewController.keyboardWillShow) { (payload) in
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: payload.endFrame.height, right: 0.0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            
            var visibleFrame = self.scrollView.frame
            visibleFrame = CGRect(x: visibleFrame.minX, y: visibleFrame.minY, width: visibleFrame.width, height: visibleFrame.height - payload.endFrame.height)
            
            guard let active = self.detailView.activeTextField else {
                return
            }
            guard !visibleFrame.contains(active.frame.origin) else { return }
            self.scrollView.scrollRectToVisible(active.frame, animated: true)

        }
        
        notificationTokens.append(keyboardWillShowToken)

        let keyboardWillHideToken = center.addObserver(forDescriptor: UIViewController.keyboardWillHide) { _ in

            // Restore view too original position
            let contentInsets = UIEdgeInsets.zero
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
        }
        
        notificationTokens.append(keyboardWillHideToken)
    }
    
    func unregisterKeyboardNotifications() {
        notificationTokens.removeAll()
    }
}

