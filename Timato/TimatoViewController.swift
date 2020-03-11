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
    var level = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        workTime = workMinutes * 60
        restTime = restMinutes * 60
        bonsaiImage.image = NSImage(named: "TimatoBonsai_8")
        timerLabel.stringValue = workTimetostring(worktime: (workTime))
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
        timer.invalidate()
        timerIsRunning = false
        workMinutes = wm
        workTime = workMinutes * 60
        timerLabel.stringValue = workTimetostring(worktime: (workTime))
    }
    
    func setRestMinutes(rm: Int) {
        restMinutes = rm
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
        labelStatus.stringValue = ("Keep Working!")
    }
    
    //azione pausa timer
    @IBAction func pauseBtn(_ sender: Any) {
        //invalidate stoppa il timer ma non lo resetta
        timer.invalidate()
        labelStatus.stringValue = ("Mhm, have a rest...")
        timerIsRunning = false
    }
    
    //azione reset timer
    @IBAction func resetBtn(_ sender: Any) {
        timer.invalidate()
        workTime = workMinutes * 60
        timerLabel.stringValue = workTimetostring(worktime: (workTime))
        labelStatus.stringValue = ("Start Working!")
        timerIsRunning = false
    }
    
    //azione quit
    @IBAction func quitBtn(_ sender: Any) {
        NSApplication.shared.terminate(sender)
    }
    
    //azione more info e settings
    @IBAction func infoBtn(_ sender: Any) {
        
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
        workTime -= 1
        print(level)
        timerLabel.stringValue = workTimetostring(worktime: (workTime))
    }
    
    func workTimetostring(worktime:Int) -> String{
        let minutes = Int(worktime) / 60 % 60
        let seconds = Int(worktime) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
}
