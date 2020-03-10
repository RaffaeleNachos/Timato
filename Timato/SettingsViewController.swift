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
        // Do view setup here.
    }
    @IBOutlet weak var fieldWorkMinutes: NSTextField!
    @IBOutlet weak var fieldRestMinutes: NSTextField!
    
    @IBAction func setRest(_ sender: Any) {
        if !fieldRestMinutes.stringValue.isEmpty {
            let r = fieldRestMinutes.integerValue
            TimatoViewController().setRest(r: r)
        }
    }
    
    @IBAction func setWork(_ sender: Any) {
        if !fieldWorkMinutes.stringValue.isEmpty {
            let w = fieldWorkMinutes.integerValue
            TimatoViewController().setWork(w: w)
        }
    }
}
