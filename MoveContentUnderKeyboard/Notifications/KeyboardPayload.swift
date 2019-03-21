//
//  NotificationDescriptor.swift
//  MoveContentUnderKeyboard
//
//  Created by wesley a sadler on 3/11/19.
//  Copyright © 2019 Digital Sadler. All rights reserved.
//

import Foundation
import UIKit

struct KeyboardPayload {
    let beginFrame: CGRect
    let endFrame: CGRect
    let curve: UIView.AnimationCurve
    let duration: TimeInterval
    let isLocal: Bool
}

extension KeyboardPayload {
    init(note: Notification) {
        let userInfo = note.userInfo
        beginFrame = userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
        endFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        curve = UIView.AnimationCurve(rawValue: userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as! Int)!
        duration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        isLocal = userInfo?[UIResponder.keyboardIsLocalUserInfoKey] as! Bool
    }
}
