//
//  PlaySoundViewController.swift
//  Pitch Perfect
//
//  Created by Ruben Ramirez on 3/30/15.
//  Copyright (c) 2015 Ruben Ramirez. All rights reserved.
//

import UIKit
import AVFoundation


class PlaySoundViewController: UIViewController {

    
    var audioPlayer:AVAudioPlayer!
    //Prepare the variable to receive data from the other side of the segue
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!

    
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Path to MP3 file
//        if var filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3") {
//            var filePathUrl = NSURL.fileURLWithPath(filePath);
//
//        } else {
//            println("The filepath is empty");
//        }
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true;
        
        // Do any additional setup after loading the view.
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
        
    }
    
    //Audio player function
    func playAudio(speed: Float) -> Float {
        audioPlayer.stop();
        audioPlayer.rate = speed;
        audioPlayer.play();
        stopButton.hidden = false;
        return 0;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.stop();
        audioEngine.stop();
        stopButton.hidden = true;
    }
    @IBAction func playFast(sender: UIButton) {
        //Call play audio function and passes fast parameters for rate
        playAudio(1.5)
    }

    @IBAction func playSlow(sender: UIButton) {
        //Call play audio function and passes slow parameters for rate
        playAudio(0.5)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
        
    }
    
    @IBAction func playSoundDarthVader(sender: UIButton) {
         playAudioWithVariablePitch(-1000)
    }
        
    func playAudioWithVariablePitch(pitch: Float){
            audioPlayer.stop()
            audioEngine.stop()
            audioEngine.reset()
            
            var audioPlayerNode = AVAudioPlayerNode()
            audioEngine.attachNode(audioPlayerNode)
            
            var changePitchEffect = AVAudioUnitTimePitch()
            changePitchEffect.pitch = pitch
            audioEngine.attachNode(changePitchEffect)
            
            audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
            audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
            
            audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
            audioEngine.startAndReturnError(nil)
            
            audioPlayerNode.play()
        }
    
 
    
}
