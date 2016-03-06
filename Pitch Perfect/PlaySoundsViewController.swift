//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Ali Kayhan on 04/03/16.
//  Copyright © 2016 Ali Kayhan. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        audioPlayer = AVAudioPlayer()
        audioEngine = AVAudioEngine()
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL)
            audioPlayer.enableRate = true
        } catch {
            print("Error while receiving the recorded audio")
        }
        
        do {
            audioFile = try AVAudioFile(forReading: receivedAudio.filePathURL)
        } catch {
            print("Error while obtaining the audio file")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playSound(rate: Float) {
            audioPlayer.stop()
            audioPlayer.rate = rate
            audioPlayer.currentTime = 0.0  // Audio starts playing from the beginning for every time.
            audioPlayer.prepareToPlay()
            audioPlayer.play()
    }
    
    func playSoundWithVariblePitch (pitch: Float) {
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let pitchEffect = AVAudioUnitTimePitch()
        pitchEffect.pitch = pitch
        audioEngine.attachNode(pitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: pitchEffect, format: nil)
        audioEngine.connect(pitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        do {
            try audioEngine.start()
            print("Audio engine has started")
        } catch {
            print("Audio engine could not start")
        }
        
        audioPlayerNode.play()
    }
    
    @IBAction func playSoundSlow(sender: UIButton) {
        playSound(0.5)
    }
    
    @IBAction func playSoundFast(sender: UIButton) {
        playSound(2.0)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playSoundWithVariblePitch(1000.00)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playSoundWithVariblePitch(-1000.00)
    }    
    
    @IBAction func stopPlaying(sender: UIButton) {
        audioPlayer.stop()
    }

}
