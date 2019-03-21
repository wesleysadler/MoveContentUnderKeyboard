//
//  NotificationCenter+Keyboard.swift
//  MoveContentUnderKeyboard
//
//  Created by wesley a sadler on 3/11/19.
//  Copyright © 2019 Digital Sadler. All rights reserved.
//

import Foundation

extension NotificationCenter {

    func addObserver<Payload>(forDescriptor descriptor: NotificationDescriptor<Payload>, using block: @escaping (Payload) -> ()) -> NotificationToken {
        let token = addObserver(forName: descriptor.name, object: nil, queue: nil, using: { (note) in
            block(descriptor.parse(note))
        })
        
         return NotificationToken(token: token, center: self)
    }
}

/*
 extension NotificationCenter {
 func addObserver<A>(forDescriptor d: NotificationDescriptor<A>, using block: @escaping (A) -> ()) -> Token {
 let t = addObserver(forName: d.name, object: nil, queue: nil, using: { note in
 block(d.convert(note))
 })
 return Token(token: t, center: self)
 }
 }
 
 var token: Token? = center.addObserver(forDescriptor: playgroundNotification, using: { print($0) })
 
 // ...
 
 token = nil
 
 
*/
