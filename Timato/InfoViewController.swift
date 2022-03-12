//
//  infoViewController.swift
//  Timato
//
//  Created by Raffaele Apetino on 10/03/2020.
//  Copyright © 2020 Raffaele Apetino. All rights reserved.
//

import Cocoa

class InfoViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func gitHyperLink(_ sender: Any) {
        if let url = URL(string: "https://github.com/RaffaeleNachos/Timato"){
            NSWorkspace.shared.open(url)
        } else {
            NSLog("Impossible to parse URL")
        }
    }
    
    @IBAction func paypalDonate(_ sender: Any) {
        if let url = URL(string: "https://paypal.me/RApetino"){
            NSWorkspace.shared.open(url)
        } else {
            NSLog("Impossible to parse URL")
        }
    }
}
