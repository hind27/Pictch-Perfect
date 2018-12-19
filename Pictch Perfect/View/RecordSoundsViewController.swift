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
        
    }
    
 // MARK: IBActions

    @IBAction func recordAudio(_ sender: Any) {
        recordingLable.text=" Tap To finish recording "
        stopButton.isEnabled=true
        recordingLable.isEnabled=false
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
    
    @IBAction func stopRecording(_ sender: Any) {
        recordingLable.isEnabled=true
        stopButton.isEnabled=false
        recordingLable.text="Tap to record"
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
        if segue.identifier == " stopRecording " {
            let playsoundVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playsoundVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}

