//
//  ViewController.swift
//  Recording
//
//  Created by Youmeiyi Pan on 4/7/17.
//  Copyright © 2017 Youmeiyi Pan. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {

    @IBOutlet weak var play: UIButton!
   
    @IBOutlet weak var record: UIButton!
    
    var sounRecorder: AVAudioRecorder!
    var playSound : AVAudioPlayer!
    var fileName = "audioplayer"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func setupRecorder() {
        let recordSettings : [String: Any] = [AVFormatIDKey : NSNumber(value: kAudioFormatAppleLossless), AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue, AVEncoderBitRateKey: 32000, AVNumberOfChannelsKey: 2, AVSampleRateKey: 44100]
        //
        var error: NSError?
        do {
        sounRecorder = try! AVAudioRecorder(url: getFileURL() as URL, settings: recordSettings)
        } catch let error1 as NSError {
            error = error1
            sounRecorder = nil
        }
        if let err = error {
            print("wrong")
        } else {
            sounRecorder.delegate = self
            sounRecorder.prepareToRecord()
        }
    }
    
    func getCacheDirectory() -> String {
        let cache = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        return cache[0]
    }
    
    func getFileURL()-> NSURL {
        let path = getCacheDirectory().appending(fileName)
        let filePath = NSURL(fileURLWithPath: path)
        return filePath
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func RecordButton(_ sender: UIButton) {
        if sender.titleLabel?.text == "Record" {
            sounRecorder.record()
            sender.setTitle("Stop", for: .normal)
            play.isEnabled = false
        } else {
            sounRecorder.stop()
            sender.setTitle("Record", for: .normal)
            play.isEnabled = false
        }
    }
 
    @IBAction func PlayButton(_ sender: UIButton) {
        if sender.titleLabel?.text == "Play" {
            record.isEnabled = false
            
            sender.setTitle("Stop", for: .normal)
            preparetoPlay()
            playSound.play()
        } else {
            playSound.stop()
            sender.setTitle("Play", for: .normal)
        }
        
    }
    
    func preparetoPlay() {
        var error: NSError?
        do {
        playSound = try! AVAudioPlayer(contentsOf: getFileURL() as URL)
        } catch let error1 as NSError{
            error = error1
            playSound = nil
        }
        
        if let err = error {
            print("Fail")
        } else {
            playSound.delegate = self
            playSound.prepareToPlay()
            playSound.volume = 1.0
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        play.isEnabled = true
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        record.isEnabled = true
        play.setTitle("Play", for: .normal)
    }
}

