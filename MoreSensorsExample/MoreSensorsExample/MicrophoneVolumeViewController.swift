//
//  MicrophoneVolumeViewController.swift
//  MoreSensorsExample
//
//  Created by Phu Nguyen Quang on 8/1/16.
//  Copyright © 2016 Phu Nguyen. All rights reserved.
//

import UIKit
import AVFoundation
import PermissionScope

class MicrophoneVolumeViewController: UIViewController {

    @IBOutlet weak var sliderFrame: UIImageView!
    @IBOutlet weak var equalizerSlider: LARSBar!
    @IBOutlet weak var toggleStartRecordButton: UIButton!
    @IBOutlet weak var lblVolume: UILabel!
    
    private var recorder: AVAudioRecorder!
    private let permissionScope = PermissionScope()
    private var timer: NSTimer?
    /// Is timer running?
    private var isRunning: Bool = false {
        didSet {
            if isRunning {
                toggleStartRecordButton.setTitle("Stop", forState: .Normal)
            } else {
                toggleStartRecordButton.setTitle("Start", forState: .Normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        permissionScope.addPermission(MicrophonePermission(), message: "We would like to use your microphone.")
        
        configEqualizerSlider()
        activateAudioSession()
        configAudioRecorder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        stopRecord()
        
        super.viewWillDisappear(animated)
    }
    
    deinit {
        print("\(self) deinit")
//        timer.invalidate()
//        timer = nil
    }
    
    // MARK: - Action
    
    @IBAction func toggleStartRecord(sender: UIButton) {
        if isRunning {
            stopRecord()
        } else {
            if permissionScope.statusMicrophone() == .Authorized {
                startRecord()
            } else {
                permissionScope.show({ (finished, results) -> Void in
                    let result = results.filter({ $0.type == .Microphone })[0]
                    if result.status != .Authorized {
                        self.showMicrophoneAccessAlert()
                    } else {
                        self.startRecord()
                    }
                    }, cancelled: { (results) -> Void in
                        self.showMicrophoneAccessAlert()
                })
            }
        }
        
    }
    
    func levelTimerCallback(timer: NSTimer) {
        recorder.updateMeters()
        print(recorder.averagePowerForChannel(0))
        let averagePower = recorder.averagePowerForChannel(0)
        lblVolume.text = String(format: "%.2f", averagePower)
        
        let max: Float = 0.0
        let min: Float = -160.0
        let percentage = CGFloat(averagePower/(min - max))
        equalizerSlider.leftChannelLevel = percentage
        equalizerSlider.rightChannelLevel = percentage
    }

    // MARK: - General
    
    private func configEqualizerSlider() {
        equalizerSlider.value = 1.0
        equalizerSlider.leftChannelLevel = 1.0
        equalizerSlider.rightChannelLevel = 1.0
        
        var backgroundImage = UIImage(named: "eq-slider-border")
        backgroundImage = backgroundImage?.resizableImageWithCapInsets(UIEdgeInsetsMake(0.0, 12.0, 0.0, 12.0))
        self.sliderFrame.image = backgroundImage
        
        let sliderKnob = UIImage(named: "slider-knob")
        equalizerSlider.setThumbImage(sliderKnob, forState: .Normal)
    }
    
    private func activateAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(true)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryRecord)
        } catch let error as NSError {
            print(error)
        }
    }
    
    private func configAudioRecorder() {
        let url = NSURL(fileURLWithPath: "/dev/null")
        let settings: Dictionary = [
            AVSampleRateKey: NSNumber(float: 44100.0),
            AVFormatIDKey: NSNumber(unsignedInt: kAudioFormatAppleLossless),
            AVNumberOfChannelsKey: NSNumber(integer: 0),
            AVEncoderAudioQualityKey: NSNumber(int: Int32(AVAudioQuality.Max.rawValue))
        ]
        
        do {
            recorder = try AVAudioRecorder(URL: url, settings: settings)
        } catch let error as NSError {
            recorder = nil
            print(error)
        }
    }
    
    private func startRecord() {
        if self.recorder != nil {
            self.recorder.prepareToRecord()
            self.recorder.meteringEnabled = true
        }
        recorder.record()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(self.levelTimerCallback(_:)), userInfo: nil, repeats: true)
        isRunning = true
    }
    
    private func stopRecord() {
        recorder.pause()
        timer?.invalidate()
        isRunning = false
    }
    
    private func showMicrophoneAccessAlert() {
        let alert = UIAlertController(title: "Microphone Access", message: "We requires access to your microphone; please enable access in your device's settings.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

}
