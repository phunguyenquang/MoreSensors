//
//  HardwareButttonPressViewController.swift
//  MoreSensorsExample
//
//  Created by Phu Nguyen Quang on 7/25/16.
//  Copyright © 2016 Phu Nguyen. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class HardwareButttonPressViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        /*let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(true)
            audioSession.addObserver(self, forKeyPath: "outputVolume", options: [], context: nil)
        } catch let error as NSError {
            print(error)
        }*/
        
        let volumeView = MPVolumeView(frame: CGRectMake(-CGFloat.max, 0.0, 0.0, 0.0))
        self.view.addSubview(volumeView)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.volumeChanged(_:)), name: "AVSystemController_SystemVolumeDidChangeNotification", object: nil)
    }

    /*override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "outputVolume" {
            print("volume changed")
            
        }
    }*/
    
    func volumeChanged(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            print(userInfo)
            if let volumeChangeType = userInfo["AVSystemController_AudioVolumeChangeReasonNotificationParameter"] as? String {
                if volumeChangeType == "ExplicitVolumeChange" {
                    print("volume changed")
                }
            }
        }
    }

}
