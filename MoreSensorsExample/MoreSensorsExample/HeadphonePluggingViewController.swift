//
//  HeadphonePluggingViewController.swift
//  MoreSensorsExample
//
//  Created by Phu Nguyen Quang on 7/26/16.
//  Copyright © 2016 Phu Nguyen. All rights reserved.
//

import UIKit
import AVFoundation

class HeadphonePluggingViewController: UIViewController {

    @IBOutlet weak var lblHeadphonePluggingStatus: UILabel!
    
    private var isHeadphoneUnplugged: Bool = true {
        didSet {
            if isHeadphoneUnplugged {
                lblHeadphonePluggingStatus.text = "Headphone unplugged"
                lblHeadphonePluggingStatus.textColor = UIColor.redColor()
            } else {
                lblHeadphonePluggingStatus.text = "🎧 Headphone plugged in"
                lblHeadphonePluggingStatus.textColor = UIColor.blueColor()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("headphone plugged in \(headsetPluggedIn())")
        isHeadphoneUnplugged = !headsetPluggedIn()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(audioRouteChangeListenerCallback(_:)), name: AVAudioSessionRouteChangeNotification, object: AVAudioSession.sharedInstance())
    }
    
    deinit {
        print("\(self) deinit")
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func audioRouteChangeListenerCallback(notif: NSNotification){
        
        let userInfo:[NSObject:AnyObject] = notif.userInfo!
        print("\(userInfo)")
        
        let routChangeReason = UInt((userInfo[AVAudioSessionRouteChangeReasonKey]?.integerValue)!)
        
        switch routChangeReason {
            
            case AVAudioSessionRouteChangeReason.NewDeviceAvailable.rawValue:
                print("Headphone/Line plugged in");
                isHeadphoneUnplugged = false
                break;
                
            case AVAudioSessionRouteChangeReason.OldDeviceUnavailable.rawValue:
                //If the headphones was pulled move to speaker
                
                do {
                    try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
                } catch let error as NSError {
                    print(error)
                }
                
                print("Headphone/Line was plugged out");
                isHeadphoneUnplugged = true
                break;
            
            default:
                break;
        }
    }

    private func headsetPluggedIn() -> Bool {
        let route = AVAudioSession.sharedInstance().currentRoute
        return route.outputs.filter({ $0.portType == AVAudioSessionPortHeadphones }).count > 0
    }

}
