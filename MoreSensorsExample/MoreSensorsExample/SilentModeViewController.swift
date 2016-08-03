//
//  SilentModeViewController.swift
//  MoreSensorsExample
//
//  Created by Phu Nguyen Quang on 8/2/16.
//  Copyright © 2016 Phu Nguyen. All rights reserved.
//

import UIKit

class SilentModeViewController: UIViewController {

    @IBOutlet weak var lblSilentModeStatus: UILabel!
    
    private var isMute: Bool = false {
        didSet {
            if isMute {
                lblSilentModeStatus.text = "🔇 ON"
                lblSilentModeStatus.textColor = UIColor.redColor()
            } else {
                lblSilentModeStatus.text = "🔊 OFF"
                lblSilentModeStatus.textColor = UIColor.blueColor()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let detector = SharkfoodMuteSwitchDetector.shared()
        isMute = detector.isMute
        
        detector.silentNotify = { (silent: Bool) in
            print(silent)
            self.isMute = silent
        }
        
        
    }

    deinit {
        print("\(self) deinit")
    }

}
