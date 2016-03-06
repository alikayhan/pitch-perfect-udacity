//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Ali Kayhan on 28/02/16.
//  Copyright © 2016 Ali Kayhan. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        recordingLabel.text = "Tap to Record"
    }

    @IBAction func recordAudio(sender: UIButton) {
        //TODO: Record user's voice
        print("Recording has started")
        recordButton.enabled = false
        recordingLabel.text = "Recording..."
        stopButton.hidden = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        // Since browsing the recorded audio files and deleting them is not possible yet, recording name is always the same and recorded audio is overwritten for each time the user records the voice.
        let recordingName = "your_recorded_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        // Setup audio session
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        // Initialize and prepare the recorder
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    // The following function is called when the recording is finished just like the ones in the view controller (lifecycle events)
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if (flag){
            // Save recorded audio
            recordedAudio = RecordedAudio(filePathURL: recorder.url, title: recorder.url.lastPathComponent)
            
            // Move to next scene with performSegueWithIdentifier rather than the hard-coded style in StoryBoard
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            print("Recording has not successfully completed.")
            recordButton.hidden = false
            recordingLabel.text = "Tap to Record"
        }
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            
            let data = sender as! RecordedAudio
            
            playSoundsVC.receivedAudio = data
        }
    }

    @IBOutlet weak var recordingLabel: UILabel!
    
    @IBAction func stopRecording(sender: UIButton) {
        
        print("Recording has stopped")
        stopButton.hidden = true
        recordButton.enabled = true
        audioRecorder.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
}

