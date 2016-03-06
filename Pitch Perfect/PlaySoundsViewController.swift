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

    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    var audioPlayerNode: AVAudioPlayerNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathURL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func playSound (rate rate: Float = 1.0, pitch: Float = 1.0) {
        
        audioEngine.stop()
        audioEngine.reset()
        
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let soundEffect = AVAudioUnitTimePitch()
        soundEffect.pitch = pitch
        soundEffect.rate = rate
        audioEngine.attachNode(soundEffect)
        
        audioEngine.connect(audioPlayerNode, to: soundEffect, format: nil)
        audioEngine.connect(soundEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        do {
            try audioEngine.start()
        } catch {
            print("Audio engine could not start")
        }
        
        audioPlayerNode.play()
    }
    
    @IBAction func playSoundSlow(sender: UIButton) {
        playSound(rate: 0.5)
    }
    
    @IBAction func playSoundFast(sender: UIButton) {
        playSound(rate: 2.0)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playSound(pitch: 1000.00)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playSound(pitch: -1000.00)
    }    
    
    @IBAction func stopPlaying(sender: UIButton) {
        audioPlayerNode.stop()
    }

}
