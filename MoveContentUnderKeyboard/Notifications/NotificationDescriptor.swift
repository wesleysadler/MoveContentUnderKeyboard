//
//  NotificationDescriptor.swift
//  MoveContentUnderKeyboard
//
//  Created by wesley a sadler on 3/11/19.
//  Copyright © 2019 Digital Sadler. All rights reserved.
//

import Foundation

struct NotificationDescriptor<Payload> {
    let name: Notification.Name
    let parse: (Notification) -> Payload
}
