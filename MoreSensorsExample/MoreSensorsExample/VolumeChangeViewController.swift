//
//  VolumeChangeViewController.swift
//  MoreSensorsExample
//
//  Created by Phu Nguyen Quang on 8/3/16.
//  Copyright © 2016 Phu Nguyen. All rights reserved.
//

import UIKit
import AVFoundation

class VolumeChangeViewController: UIViewController {

    @IBOutlet weak var volumeSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        volumeSlider.userInteractionEnabled = false
        
        let volume = AVAudioSession.sharedInstance().outputVolume
        print("Output volume: \(volume)")
        volumeSlider.value = volume
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(true)
            audioSession.addObserver(self, forKeyPath: "outputVolume", options: NSKeyValueObservingOptions.New, context: nil)
        } catch let error as NSError {
            print(error)
        }
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        print(change)
        if keyPath == "outputVolume", let changeObject = change, let volume = changeObject["new"] as? Float {
            print("volume changed to \(volume)")
            volumeSlider.value = volume
        }
    }

    deinit {
        print("\(self) deinit")
    }
}
