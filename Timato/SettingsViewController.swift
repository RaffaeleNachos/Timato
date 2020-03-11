//
//  SettingsViewController.swift
//  Timato
//
//  Created by Raffaele Apetino on 09/03/2020.
//  Copyright © 2020 Raffaele Apetino. All rights reserved.
//

import Cocoa

class SettingsViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    weak var delegate:TimatoViewController!
    
    @IBOutlet weak var fieldWorkMinutes: NSTextField!
    @IBOutlet weak var fieldRestMinutes: NSTextField!
    
    @IBAction func setRest(_ sender: Any) {
        delegate.setRestMinutes(rm: fieldRestMinutes.integerValue)
    }
    
    @IBAction func setWork(_ sender: Any) {
        delegate.setWorkMinutes(wm: fieldWorkMinutes.integerValue)
    }
    
}
