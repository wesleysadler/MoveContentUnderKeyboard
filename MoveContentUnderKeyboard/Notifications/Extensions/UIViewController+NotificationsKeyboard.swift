//
//  UIViewController+NotificationsKeyboard.swift
//  MoveContentUnderKeyboard
//
//  Created by wesley a sadler on 3/11/19.
//  Copyright © 2019 Digital Sadler. All rights reserved.
//

import UIKit

extension UIViewController {
    static let keyboardWillShow = NotificationDescriptor(name: UIResponder.keyboardWillShowNotification, parse: KeyboardPayload.init)
    static let keyboardWillHide = NotificationDescriptor(name: UIResponder.keyboardWillHideNotification, parse: KeyboardPayload.init)
}
