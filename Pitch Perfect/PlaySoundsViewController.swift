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
    
    func playSound (rate rate: Float = 1.0, pitch: Float = 1.0, delayTime: Float = 0.0, wetDryMix: Float = 0) {
        
        stopAudioEngine()
        
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let soundEffect = AVAudioUnitTimePitch()
        soundEffect.pitch = pitch
        soundEffect.rate = rate
        audioEngine.attachNode(soundEffect)
        
        let echoEffect = AVAudioUnitDelay()
        echoEffect.delayTime = NSTimeInterval(delayTime)
        audioEngine.attachNode(echoEffect)
        
        let reverbEffect = AVAudioUnitReverb()
        reverbEffect.wetDryMix = wetDryMix
        audioEngine.attachNode(reverbEffect)
        
        audioEngine.connect(audioPlayerNode, to: soundEffect, format: nil)
        audioEngine.connect(soundEffect, to: echoEffect, format: nil)
        audioEngine.connect(echoEffect, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        do {
            try audioEngine.start()
        } catch {
            print("Audio engine could not start")
        }
        
        audioPlayerNode.play()
    }
    
    func stopAudioEngine() {
        audioEngine.stop()
        audioEngine.reset()
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
    
    @IBAction func playEchoAudio(sender: UIButton) {
        playSound(delayTime: 1.0)
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        playSound(wetDryMix: 60)
    }
    
    @IBAction func stopPlaying(sender: UIButton) {
        stopAudioEngine()
        audioPlayerNode.stop()
    }

}
