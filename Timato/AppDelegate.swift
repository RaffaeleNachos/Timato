//
//  AppDelegate.swift
//  Timato
//
//  Created by Raffaele Apetino on 07/02/2020.
//  Copyright © 2020 Raffaele Apetino. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate{

    //crea l'icona della status bar
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    
    //definisco la schermata di popUp
    let popover = NSPopover()
    
    //istanza del monitor per permettere la chiusura del popover quando cliccato fuori dalla finestra
    var eventMonitor: EventMonitor?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
          button.image = NSImage(named:NSImage.Name("TimatoStatusBarIcon"))
          button.action = #selector(togglePopover(_:))
        }
        popover.contentViewController = TimatoViewController.freshController()
        
        //creo istanza event monitor che cattura i click del mouse
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) {
            [weak self] event in
            if let strongSelf = self, strongSelf.popover.isShown {
                    strongSelf.closePopover(sender: event)
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    //funzione che mi apre e chiuse il la scermata di popUp
    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }

    func showPopover(sender: Any?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
        //lancio l'event monitor che cattura se si clicca con il mouse
        eventMonitor?.start()
    }

    func closePopover(sender: Any?) {
        popover.performClose(sender)
        //ovviamente quando il popover è chiuso termino l'event monitoring
        eventMonitor?.start()
    }

}
