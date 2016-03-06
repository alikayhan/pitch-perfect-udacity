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
    @IBOutlet weak var recordingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupReadyToRecordView() {
        recordButton.enabled = true
        recordingLabel.text = "Tap to Record"
        stopButton.hidden = true
    }
    
    func setupRecordingNowView() {
        recordButton.enabled = false
        recordingLabel.text = "Recording..."
        stopButton.hidden = false
    }
    
    override func viewWillAppear(animated: Bool) {
        setupReadyToRecordView()
    }

    @IBAction func recordAudio(sender: UIButton) {
        setupRecordingNowView()
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let recordingName = "your_recorded_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
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
    
    @IBAction func stopRecording(sender: UIButton) {
        audioRecorder.stop()
        
        // Deactivate audio session
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            // Save recorded audio
            recordedAudio = RecordedAudio(filePathURL: recorder.url, title: recorder.url.lastPathComponent)
            
            // Move to next scene
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            print("Recording has not successfully completed.")
            setupReadyToRecordView()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            
            let data = sender as! RecordedAudio
            
            playSoundsVC.receivedAudio = data
        }
    }
    
}
