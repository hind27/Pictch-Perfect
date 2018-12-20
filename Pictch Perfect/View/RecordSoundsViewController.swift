//
//  RecordSoundsViewController.swift
//  Pictch Perfect
//
//  Created by hind on 12/18/18.
//  Copyright © 2018 hind. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController ,AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    @IBOutlet weak var recordingLable: UILabel!
    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.isEnabled=false
        self.navigationItem.title = "Pitch Perfect"
    }
    
 // MARK:  - IBActions

   
    @IBAction func recordAudio(_ sender: Any) {
       
        configureUI(true)
        
        // it's used to get the directory path by document dicrectory to store  the audio recording
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        //combine  the both the directory path and recording name to create afull path
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        // it share AVAudiosession across all apps on our dvevice
        let session = AVAudioSession.sharedInstance()
        // setup the session for playing and  recording audio
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    func configureUI(_ isRecording:Bool = false) {
        recordingLable.text = isRecording ? "Recording in progress": "Tap to Record"
            stopButton.isEnabled = isRecording
            recordingButton.isEnabled = !isRecording
        }
    

    @IBAction func stopRecording(_ sender: Any) {
        configureUI(false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }

    
// MARK: - Audio Recorder Delegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag
        {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else {
            print("recording is not sucessful")
        }
    }
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        if segue.identifier == "stopRecording" {
            let playsoundVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = audioRecorder.url
            playsoundVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}

