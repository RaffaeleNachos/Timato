//
//  TimatoWiewController.swift
//  Timato
//
//  Created by Raffaele Apetino on 19/02/2020.
//  Copyright © 2020 Raffaele Apetino. All rights reserved.
//

import Cocoa

class TimatoViewController: NSViewController {
    
    var timer = Timer()
    var timerIsRunning = false
    var workTime = 45
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        bonsaiImage.image = NSImage(named: "TimatoBonsai_0")
    }
    
    //label del timer
    @IBOutlet weak var timerLabel: NSTextField!
    //immagine bonsai
    @IBOutlet weak var bonsaiImage: NSImageView!
    
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
            fatalError("Why cant i find QuotesViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}

extension TimatoViewController {
    
    // MARK: azione bottoni gui
    
    //azione inizio timer
    @IBAction func playBtn(_ sender: Any) {
        print("play")
        timerIsRunning = true
        runTimer()
    }
    
    //azione pausa timer
    @IBAction func pauseBtn(_ sender: Any) {
        print("pause")
        //stoppa il timer ma non lo resetta
        timer.invalidate()
        timerIsRunning = false
    }
    
    //azione pausa timer
    @IBAction func settingsBtn(_ sender: Any) {
        
    }
    
    //azione pausa timer
    @IBAction func quitBtn(_ sender: Any) {
       
    }
    
    //azione pausa timer
    @IBAction func infoBtn(_ sender: Any) {
        
    }
}

extension TimatoViewController {
    // MARK: funzioni timer
    
    //schedula un thread che si occupa di chiamare onti timeInterval (in secondi) il metodo updateTimer definito in questa classe
    func runTimer() {
         timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(TimatoViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(){
        workTime -= 1
        timerLabel.insertText("\(workTime)")
    }
}
