//
//  PromodoroViewController.swift
//  To-DoWithPromodoro
//
//  Created by MYMACBOOK on 14.02.2021.
//  Copyright © 2021 ElifKorkmaz. All rights reserved.
//

import UIKit
import AVFoundation

class PromodoroViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var labelMinute: UILabel!
    @IBOutlet weak var labelSecond: UILabel!
    @IBOutlet weak var buttonStopResume: UIButton!
    @IBOutlet weak var buttonBreak: UIButton!
    
    var timer = Timer()
    var player: AVAudioPlayer!
    
    var workTime = 25*60
    var breakTime = 5*60
    var timeRemaining = 0
    var isBreak = false

    override func viewDidLoad() {
        super.viewDidLoad()
        timeRemaining = workTime
        changeTimer(timeRemaining)
        
        do {
            let filePath = Bundle.main.path(forResource: "music", ofType: ".mp3")
            player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: filePath!))
            player.prepareToPlay()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerMethod), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    @objc func timerMethod() {
        if timeRemaining > 0 {
            timeRemaining -= 1
            updateLabel()

        } else {
            buttonBreak.isHidden = false
            buttonBreak.isEnabled = true
            stopTimer()
        }
    }
    
    func changeTimer(_ : Int) {
        buttonBreak.isEnabled = false
        buttonBreak.isHidden = true
        updateLabel()
    }
    
    @IBAction func soundOnOff(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            player.stop()
        case 1:
            player.play()
        default:
            break
        }
    }
    
    @IBAction func start(_ sender: Any) {
         timeRemaining = workTime
         nextPromodoro()
         updateLabel()
    }
    @IBAction func resumeStop(_ sender: Any) {
        isBreak = false
        if timer.isValid {
            buttonStopResume.setTitle("RESUME", for: .normal)
            stopTimer()
        } else {
            buttonStopResume.setTitle("STOP", for: .normal)
            buttonBreak.isEnabled = false
            
            nextPromodoro()
            startTimer()
        }
    }
    
    @IBAction func buttonBreak(_ sender: Any) {
        isBreak = true
        timeRemaining = breakTime
        changeTimer(timeRemaining)
        startTimer()
        buttonStopResume.setTitle("START", for: .normal)
    }
    
    func nextPromodoro() {
       if !isBreak  {
            changeTimer(timeRemaining)
        }
    }
    
    @objc func updateLabel() {
        let (minutes, seconds) = minutesAndSeconds(from: timeRemaining)
        labelMinute.text = "\(formatMinuteOrSecond(minutes)) :"
        labelSecond.text = formatMinuteOrSecond(seconds)
    }
      // Given a number of seconds, return it as (minutes, seconds).
     func minutesAndSeconds(from seconds: Int) -> (Int, Int) {
       return (seconds / 60, seconds % 60)
     }
    
     // Given a number, return it as a string of 2 digits,
     // with a leading zero if necessary.
     func formatMinuteOrSecond(_ number: Int) -> String {
       return String(format: "%02d", number)
     }
}
