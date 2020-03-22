//
//  TimatoNotifications.swift
//  Timato
//
//  Created by Raffaele Apetino on 16/03/2020.
//  Copyright © 2020 Raffaele Apetino. All rights reserved.
//

import Cocoa

class TimatoNotifications {
    
    let worknotification = NSUserNotification()
    let restnotification = NSUserNotification()
    
    init(){
        
        worknotification.title = "Timato"
        worknotification.subtitle = "Hey! You must work NOW!"
        worknotification.soundName = NSUserNotificationDefaultSoundName
        
        restnotification.title = "Timato"
        restnotification.subtitle = "Hey! You can have a nap :)"
        restnotification.soundName = NSUserNotificationDefaultSoundName
    }
    
    func setWorkID(id: String){
        worknotification.identifier = id
    }
    
    func setRestID(id: String){
         restnotification.identifier = id
    }
}
