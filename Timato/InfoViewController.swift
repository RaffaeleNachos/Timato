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
        let url = URL(string: "https://github.com/RaffaeleNachos/Timato")!
        NSWorkspace.shared.open(url)
    }
    
    @IBAction func paypalDonate(_ sender: Any) {
        let url = URL(string: "https://paypal.me/RApetino")!
        NSWorkspace.shared.open(url)
    }
}
