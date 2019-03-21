//
//  NotificationToken.swift
//  MoveContentUnderKeyboard
//
//  Created by wesley a sadler on 3/11/19.
//  Copyright © 2019 Digital Sadler. All rights reserved.
//

import Foundation

class NotificationToken {
    let token: NSObjectProtocol
    let center: NotificationCenter
    init(token: NSObjectProtocol, center: NotificationCenter) {
        self.token = token
        self.center = center
    }
    
    deinit {
        center.removeObserver(token)
    }
}
