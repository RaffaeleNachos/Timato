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
        worknotification.identifier = "worknotify"
        worknotification.title = "Timato"
        worknotification.subtitle = "Hey!, You must work NOW!"
        //worknotification.contentImage = NSImage(named: "AppIcon")
        worknotification.soundName = NSUserNotificationDefaultSoundName
        
        restnotification.identifier = "restnotify"
        restnotification.title = "Timato"
        restnotification.subtitle = "Hey!, You can have a nap :)"
        //worknotification.contentImage = NSImage(named: "AppIcon")
        restnotification.soundName = NSUserNotificationDefaultSoundName
    }
}
