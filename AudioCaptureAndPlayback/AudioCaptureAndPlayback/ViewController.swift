//
//  ViewController.swift
//  AudioCaptureAndPlayback
//
//  Created by Clayton Cornett on 10/31/19.
//  Copyright © 2019 Clayton Cornett. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    @IBOutlet weak var recordBarButton: UIBarButtonItem!
    @IBOutlet weak var playBarButton: UIBarButtonItem!
    
    var fileManger: FileManager?
    var documentDirectory: URL?
    
    var audioSession: AVAudioSession?
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var fileName = "recording.caf"
    var fileURL: URL?
    //var recordingSettings: [String: Any]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let fileManager = FileManager.default
        
        documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        fileURL = documentDirectory?.appendingPathComponent(fileName)
        
        audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession?.setCategory(.playAndRecord, mode: .default, options: [])
        }catch{
            print("error")
        }
        
        audioSession?.requestRecordPermission(){
            [unowned self] allowed in
            if allowed{
                let _ = self.audioSession
                let _ = self.audioRecorder
            }
            else{
                print("no permission")
            }
        }
        
        let recordingSettings =
            [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
             AVEncoderBitRateKey: 16,
             AVNumberOfChannelsKey: 2,
             AVSampleRateKey: 44100.0] as [String : Any]
        
        do {
            try audioRecorder = AVAudioRecorder(url: fileURL!, settings: recordingSettings)
            audioRecorder?.delegate = self
        } catch {
            print("error with url")
        }
    }


    @IBAction func recordPressed(_ sender: Any) {
            
        
        if(audioRecorder?.isRecording == false){
            playBarButton.isEnabled = false
            recordBarButton.title = "stop"
            audioRecorder?.record()
        }
        else{
            playBarButton.isEnabled = true
            recordBarButton.title = "record"
            audioRecorder?.stop()
        }
        
    
    }
    
    
    
    @IBAction func playPressed(_ sender: Any) {
        
        
        if(audioRecorder?.isRecording == true){
            print("cant play while recording")
            return
        }
        
        if let audioPlayer = audioPlayer {
            
            if(audioPlayer.isPlaying){
                audioPlayer.stop()
                
                playBarButton.title = "Play"
                recordBarButton.isEnabled = true
                return
            }
        }
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL!)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            
            audioPlayer?.play()
            
            recordBarButton.isEnabled = false
            playBarButton.title = "stop"
        } catch {
            print("play error")
            return
        }
        
        
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playBarButton.title = "Play"
        recordBarButton.isEnabled = true
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("error")
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("error")
    }
    
    
}

