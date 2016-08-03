//
//  MusicPlayingViewController.swift
//  MoreSensorsExample
//
//  Created by Phu Nguyen Quang on 7/26/16.
//  Copyright © 2016 Phu Nguyen. All rights reserved.
//

import UIKit
import AVFoundation

class MusicPlayingViewController: UIViewController {
    
    @IBOutlet weak var lblAudioPlayingStatus: UILabel!
    
    private var isAudioPlaying: Bool = false {
        didSet {
            if isAudioPlaying {
                lblAudioPlayingStatus.text = "🎶 Audio playing ..."
            } else {
                lblAudioPlayingStatus.text = "No audio playing"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("other audio playing: \(AVAudioSession.sharedInstance().secondaryAudioShouldBeSilencedHint)")
        isAudioPlaying = AVAudioSession.sharedInstance().secondaryAudioShouldBeSilencedHint
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            print(error)
        }
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(anotherAudioPlaying(_:)), name: AVAudioSessionSilenceSecondaryAudioHintNotification, object: nil)
    }
    
    deinit {
        print("\(self) deinit")
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func anotherAudioPlaying(notification: NSNotification) {
        
        if let userInfo = notification.userInfo, let audioHintType = userInfo[AVAudioSessionSilenceSecondaryAudioHintTypeKey] as? Int {
            print(audioHintType)
            if audioHintType == 0 {
                isAudioPlaying = false
            } else if audioHintType == 1 {
                isAudioPlaying = true
            }
        }
        
    }
    
    

}
