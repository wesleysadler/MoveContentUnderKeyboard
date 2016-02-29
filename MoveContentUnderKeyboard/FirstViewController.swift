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
    
    // MARK: View Controller Lifecycle
    
    deinit {
        self.deregisterFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.registerForKeyboardNotifications()
        
        let firstViewModel = FirstViewModel(birdName: "American Robin", scientificName: "Turdus-migratorius", birdImageFileName: "Turdus-migratorius.png")
        
        detailView.configure(withPresenter: firstViewModel)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Keyboard Notifications for keyboard
    
    func registerForKeyboardNotifications() {
        // Adding notifies on keyboard show and hide
        NSNotificationCenter.defaultCenter().addObserver(detailView, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(detailView, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func deregisterFromKeyboardNotifications() {
        // Removing notifies on keyboard show and hide
        NSNotificationCenter.defaultCenter().removeObserver(detailView, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(detailView, name: UIKeyboardWillHideNotification, object: nil)
    }

}

