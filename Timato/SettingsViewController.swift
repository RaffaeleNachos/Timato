//
//  SettingsViewController.swift
//  Timato
//
//  Created by Raffaele Apetino on 09/03/2020.
//  Copyright © 2020 Raffaele Apetino. All rights reserved.
//

import Cocoa

class SettingsViewController: NSViewController {
    
    weak var delegate: TimatoViewController?
    
    @IBOutlet weak var fieldWorkMinutes: NSTextField!
    @IBOutlet weak var fieldRestMinutes: NSTextField!
    @IBOutlet weak var notificationCheckBox: NSButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        guard let delegate = delegate else {
            NSLog("Delegate not set")
            return
        }
        
        if (delegate.notificationsEnabled){
            self.notificationCheckBox.state = .on
        } else {
            self.notificationCheckBox.state = .off
        }
    }
    
    @IBAction func notificationOnOff(_ sender: NSButton) {
        guard let delegate = delegate else {
            NSLog("Delegate not set")
            return
        }
        
        if sender.state == .on {
            delegate.setNotificationsStatus(state: true)
        } else {
            delegate.setNotificationsStatus(state: false)
        }
    }
    
    @IBAction func setRest(_ sender: Any) {
        guard let delegate = delegate else {
            NSLog("Delegate not set")
            return
        }
        
        let restMinutes = fieldRestMinutes.integerValue;
        guard restMinutes != 0 else {
            fieldRestMinutes.shake(duration: 1.0)
            NSLog("Invalid time value");
            return
        }
        
        delegate.setRestMinutes(rm: restMinutes)
    }
    
    @IBAction func setWork(_ sender: Any) {
        guard let delegate = delegate else {
            NSLog("Delegate not set")
            return
        }
        
        let workMinutes = fieldWorkMinutes.integerValue;
        guard workMinutes != 0 else {
            fieldWorkMinutes.shake(duration: 1.0)
            NSLog("Invalid time value");
            return
        }
        
        delegate.setWorkMinutes(wm: workMinutes)
    }
    
}
