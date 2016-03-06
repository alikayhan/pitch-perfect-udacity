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
    
    var audioPlayer = AVAudioPlayer()
    var receivedAudio: RecordedAudio!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL)
            audioPlayer.enableRate = true
        } catch {
            print("Error while receiving the recorded audio")
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
    
    @IBAction func playSoundSlow(sender: UIButton) {
        playSound(0.5)
    }
    
    @IBAction func playSoundFast(sender: UIButton) {
        playSound(2.0)
    }
    
    @IBAction func stopPlaying(sender: UIButton) {
        audioPlayer.stop()
    }

}
