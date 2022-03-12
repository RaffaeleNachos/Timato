//
//  TimatoWiewController.swift
//  Timato
//
//  Created by Raffaele Apetino on 19/02/2020.
//  Copyright © 2020 Raffaele Apetino. All rights reserved.
//

import Cocoa
import UserNotifications

//decoupling is the key
protocol TimerValuesSetter{
    func setWorkMinutes(wm: Int)
    func setRestMinutes(rm: Int)
}

class TimatoViewController: NSViewController, TimerValuesSetter{
    var timer = Timer()
    var timerIsRunning = false
    var workMinutes = 45
    var restMinutes = 15
    var workTime = 0
    var restTime = 0
    var level = 0
    //tmode = true WORK
    //tmode = false REST
    var tmode = true
    var notificationsEnabled = false
    
    //notifications
    var tnotifcations = TimatoNotifications()
    var notificationCenter = UNUserNotificationCenter.current()
    
    //label sopra al timer indica work/rest/pause
    @IBOutlet weak var labelStatus: NSTextField!
    //label del timer
    @IBOutlet weak var timerLabel: NSTextField!
    //immagine bonsai
    @IBOutlet weak var bonsaiImage: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        workTime = workMinutes * 60
        restTime = restMinutes * 60
        bonsaiImage.image = NSImage(named: "TimatoBonsai_0")
        timerLabel.stringValue = timerTimetostring(worktime: (workTime))
        labelStatus.stringValue = ("Start Working!")
        settingsPopover.behavior = NSPopover.Behavior.transient
        self.askForNotificationPermission()
    }
    
    //funzioni chiamate dal view controller delle impostazioni per cambiare i valori del work e rest minutes
    func setWorkMinutes(wm: Int) {
        workMinutes = wm
        workTime = workMinutes * 60
        if (tmode) {
            timer.invalidate()
            timerIsRunning = false
            timerLabel.stringValue = timerTimetostring(worktime: (workTime))
        }
    }
    
    func setRestMinutes(rm: Int) {
        restMinutes = rm
        restTime = restMinutes * 60
        if (!tmode){
            timer.invalidate()
            timerIsRunning = false
            timerLabel.stringValue = timerTimetostring(worktime: (restTime))
        }
    }
    
    //funzione per lo stato delle notifiche abilitate o non
    func setNotificationsStatus(state: Bool) {
        notificationsEnabled = state
    }
    
    func askForNotificationPermission(){
        //ask for notifications auth, if not already auth
        notificationCenter.getNotificationSettings { settings in
            if (settings.authorizationStatus != .authorized){
                self.notificationsEnabled = false
                self.notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, err in
                    guard err == nil else {
                        NSLog("Request Auth for notifications failed: %@", err.debugDescription)
                        return
                    }
                    
                    if (granted){
                        self.notificationsEnabled = true
                        NSLog("Notifications authorized")
                    } else {
                        self.notificationsEnabled = false
                        NSLog("Notifications not authorized")
                    }
                }
            } else {
                self.notificationsEnabled = true
            }
        }
    }
    
    //popover per settingsviewcontroller
    let settingsPopover = NSPopover()
    
    @IBOutlet weak var settingsBtnOutlet: NSButton!
    
}

extension TimatoViewController {
    // MARK: istanziazione controller
    
    static func freshController() -> TimatoViewController {
        //ottengo la reference della StoryBoard
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        //crea identificatore che combacia con quello settato nella storyboard
        let identifier = NSStoryboard.SceneIdentifier("TimatoViewController")
        //istanzia il controller
        //guard + fatal error
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? TimatoViewController else {
            fatalError("Why cant i find it? - Check Main.storyboard")
        }
        return viewcontroller
    }
}

extension TimatoViewController {
    
    // MARK: azione bottoni gui
    
    //azione inizio timer
    @IBAction func playBtn(_ sender: Any) {
        if timerIsRunning == false {
            runTimer()
        }
        timerIsRunning = true
        if (tmode){
            labelStatus.stringValue = ("Keep Working!")
        } else {
            labelStatus.stringValue = ("Take a looong rest...")
        }
    }
    
    //azione pausa timer
    @IBAction func pauseBtn(_ sender: Any) {
        //invalidate stoppa il timer ma non lo resetta
        timer.invalidate()
        labelStatus.stringValue = ("Mhm, have a short break...")
        timerIsRunning = false
    }
    
    //azione reset timer
    @IBAction func resetBtn(_ sender: Any) {
        timer.invalidate()
        if (tmode){
            workTime = workMinutes * 60
            timerLabel.stringValue = timerTimetostring(worktime: (workTime))
            labelStatus.stringValue = ("Start Working!")
            timerIsRunning = false
        } else {
            restTime = restMinutes * 60
            timerLabel.stringValue = timerTimetostring(worktime: (restTime))
            labelStatus.stringValue = ("Take a looong rest...")
            timerIsRunning = false
        }
    }
    
    //azione quit
    @IBAction func quitBtn(_ sender: Any) {
        NSApplication.shared.terminate(sender)
    }
    
    //apertura della view delle impostazioni
    @IBAction func settingsBtn(_ sender: Any) {
        if settingsPopover.isShown {
            settingsPopover.performClose(sender)
        } else {
            //ottengo la reference della StoryBoard
            let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
            //crea identificatore che combacia con quello settato nella storyboard
            let identifier = NSStoryboard.SceneIdentifier("SettingsViewController")
            //istanzia il controller
            //guard + fatal error
            if settingsPopover.contentViewController == nil {
                if let settingsViewController = storyboard.instantiateController(withIdentifier: identifier) as? SettingsViewController {
                    settingsViewController.delegate = self
                    settingsPopover.contentViewController = settingsViewController
                    settingsPopover.show(relativeTo: settingsBtnOutlet.bounds, of: settingsBtnOutlet, preferredEdge: NSRectEdge.minY)
                }
            } else {
                settingsPopover.show(relativeTo: settingsBtnOutlet.bounds, of: settingsBtnOutlet, preferredEdge: NSRectEdge.minY)
            }
        }
    }
}

extension TimatoViewController {
    // MARK: funzioni accessorie timer
    
    //schedula un thread che si occupa di chiamare onti timeInterval (in secondi) il metodo updateTimer definito in questa classe
    func runTimer() {
         timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(TimatoViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(){
        if (tmode){
            workTime -= 1
            if (workTime <= 0){
                if (notificationsEnabled){
                    notificationCenter.add(tnotifcations.requestForRestNotirication()) { err in
                        guard err == nil else {
                            return
                        }
                    }
                }
                tmode = !tmode
                if level < 9 {
                    level += 1
                }
                bonsaiImage.image = NSImage(named: "TimatoBonsai_\(level)")
                resetBtn(self)
                playBtn(self)
            }
            timerLabel.stringValue = timerTimetostring(worktime: (workTime))
        } else {
            restTime -= 1
            if (restTime <= 0){
                if (notificationsEnabled){
                    notificationCenter.add(tnotifcations.requestForWorkNotirication()) { err in
                        guard err == nil else {
                            return
                        }
                    }
                }
                tmode = !tmode
                resetBtn(self)
                playBtn(self)
            }
            timerLabel.stringValue = timerTimetostring(worktime: (restTime))
        }
    }
    
    func timerTimetostring(worktime:Int) -> String{
        let minutes = Int(worktime) / 60 % 60
        let seconds = Int(worktime) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
}
