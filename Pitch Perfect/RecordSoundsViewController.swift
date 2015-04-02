//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Ruben Ramirez on 3/29/15.
//  Copyright (c) 2015 Ruben Ramirez. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    //Declare the label as an outlet
    @IBOutlet weak var recordingAudio: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        //Hide the stop button
        stopButton.hidden = true;
        recordButton.enabled = true;
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        //Unhide Stop Button
        stopButton.hidden = false;
        //Unhide the recording label
        recordingAudio.hidden = false;
        //Disable record button after was pressed once
        recordButton.enabled = false;
        //Find the path to store  audio
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        //Create the filepath
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        //create a new session to start recording.
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        //let the recording happen
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self;
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        if(flag){
            //Initialize the variable as new instance
            recordedAudio = RecordedAudio()
        
            // Get title and path from the parameters
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
        
        
            //Move to next page when hitting STOP
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording")
        {
            //Define a variable to be able to access the clas playsoundsviewcontroller
            let playSoundsVC:PlaySoundViewController = segue.destinationViewController as PlaySoundViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }

    @IBAction func stopRecording(sender: UIButton) {
        //Hide the recording label
        recordingAudio.hidden = true;
        audioRecorder.stop();
        var audioSession = AVAudioSession.sharedInstance();
        audioSession.setActive(false, error: nil);
    }
    
}

