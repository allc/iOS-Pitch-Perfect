//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Allen on 15/1/10.
//  Copyright (c) 2015年 myhuoban. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var releaseToFinish: UILabel!
    @IBOutlet weak var pressLonger: UILabel!
    
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        // Hide the stop button
        releaseToFinish.hidden = true
        recordButton.enabled = true
        pressLonger.hidden = true
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag) {
            //TODO: 1.Save the recorded audio
            recordedAudio = RecordedAudio()
            recordedAudio.filePath = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            
            //TODO: 2.Move to the next scene aka perform segue
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Recording was not successful")
            recordButton.enabled = true
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundVC: PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundVC.receivedAudio = data
        }
    }
    
    @IBAction func begainRecord(sender: UIButton) {
        recordButton.enabled = false
        //TODO: Show text "recording in progress"
        recordingInProgress.hidden = false
        releaseToFinish.hidden = false
        pressLonger.hidden = true
        
        //TODO: record the user's voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        // Initialize and prepare the recorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func finishRecord(sender: UIButton) {
        if (audioRecorder.currentTime >= 0.5) {
            //TODO: Hide text "recording in progress"
            recordingInProgress.hidden = true
            releaseToFinish.hidden = true
            pressLonger.hidden = true
            audioRecorder.stop()
            var audioSession = AVAudioSession.sharedInstance()
            audioSession.setActive(false, error: nil)
        } else {
            recordButton.enabled = true
            recordingInProgress.hidden = true
            releaseToFinish.hidden = true
            pressLonger.hidden = false
        }
    }
    
}