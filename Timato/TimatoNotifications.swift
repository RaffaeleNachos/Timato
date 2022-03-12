//
//  TimatoNotifications.swift
//  Timato
//
//  Created by Raffaele Apetino on 16/03/2020.
//  Copyright © 2020 Raffaele Apetino. All rights reserved.
//

import Cocoa
import UserNotifications

class TimatoNotifications {
    
    let trigger : UNTimeIntervalNotificationTrigger
    let worknotification = UNMutableNotificationContent()
    let restnotification = UNMutableNotificationContent()
    
    init(){
        trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        
        worknotification.title = "Timato"
        worknotification.subtitle = "Hey! You must work NOW!"
        worknotification.sound = UNNotificationSound.default
        
        restnotification.title = "Timato"
        restnotification.subtitle = "Hey! You can have a nap :)"
        restnotification.sound = UNNotificationSound.default
    }
    
    func requestForWorkNotirication() -> UNNotificationRequest{
        return UNNotificationRequest(identifier: UUID().uuidString, content: worknotification, trigger: trigger)
    }
    
    func requestForRestNotirication() -> UNNotificationRequest{
        return UNNotificationRequest(identifier: UUID().uuidString, content: restnotification, trigger: trigger)
    }
}
