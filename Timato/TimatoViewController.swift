//
//  TimatoWiewController.swift
//  Timato
//
//  Created by Raffaele Apetino on 19/02/2020.
//  Copyright © 2020 Raffaele Apetino. All rights reserved.
//

import Cocoa

//decoupling is the key
protocol setTings{
    func setWorkMinutes(wm: Int)
    func setRestMinutes(rm: Int)
}

class TimatoViewController: NSViewController, setTings{
    var timer = Timer()
    var timerIsRunning = false
    var workMinutes = 45
    var restMinutes = 15
    var workTime = 0
    var restTime = 0
    var level = 5
    //tmode = true WORK
    //tmode = false REST
    var tmode = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        workTime = workMinutes * 60
        restTime = restMinutes * 60
        bonsaiImage.image = NSImage(named: "TimatoBonsai_1")
        timerLabel.stringValue = timerTimetostring(worktime: (workTime))
        labelStatus.stringValue = ("Start Working!")
    }
    //label sopra al timer indica work/rest/pause
    @IBOutlet weak var labelStatus: NSTextField!
    //label del timer
    @IBOutlet weak var timerLabel: NSTextField!
    //immagine bonsai
    @IBOutlet weak var bonsaiImage: NSImageView!
    
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
    
    //popover per settingsviewcontroller
    let popover = NSPopover()
    
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
            labelStatus.stringValue = ("Take a looong break...")
            timerIsRunning = false
        }
    }
    
    //azione quit
    @IBAction func quitBtn(_ sender: Any) {
        NSApplication.shared.terminate(sender)
    }
    
    //apertura della view delle impostazioni
    @IBAction func settingsBtn(_ sender: Any) {
        if popover.isShown {
            popover.performClose(sender)
        } else {
            //ottengo la reference della StoryBoard
            let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
            //crea identificatore che combacia con quello settato nella storyboard
            let identifier = NSStoryboard.SceneIdentifier("SettingsViewController")
            //istanzia il controller
            //guard + fatal error
            let viewsetcontroller = storyboard.instantiateController(withIdentifier: identifier) as? SettingsViewController
            viewsetcontroller?.delegate = self
            popover.contentViewController = viewsetcontroller
            popover.show(relativeTo: settingsBtnOutlet.bounds, of: settingsBtnOutlet, preferredEdge: NSRectEdge.minY)
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
                tmode = !tmode
                if level < 9 {
                    level += 1
                }
                bonsaiImage.image = NSImage(named: "TimatoBonsai_\(level)")
                resetBtn(self)
                runTimer()
            }
            timerLabel.stringValue = timerTimetostring(worktime: (workTime))
        } else {
            restTime -= 1
            if (restTime <= 0){
                tmode = !tmode
                resetBtn(self)
                runTimer()
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
