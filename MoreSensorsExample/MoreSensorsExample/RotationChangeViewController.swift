//
//  RotationChangeViewController.swift
//  MoreSensorsExample
//
//  Created by Phu Nguyen Quang on 7/28/16.
//  Copyright © 2016 Phu Nguyen. All rights reserved.
//

import UIKit

class RotationChangeViewController: UIViewController {

    @IBOutlet weak var lblCurrentRotation: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showCurrentOrientation()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RotationChangeViewController.rotated), name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    deinit {
        print("\(self) deinit")
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func rotated() {
        showCurrentOrientation()
    }
    
    private func showCurrentOrientation() {
        if !UIDevice.currentDevice().orientation.orientationString.isEmpty {
            lblCurrentRotation.text = UIDevice.currentDevice().orientation.orientationString
        }
    }

}

extension UIDeviceOrientation {
    
    var orientationString: String {
        switch self {
            case .Portrait: return "Portrait"
            case .PortraitUpsideDown: return "Portrait Upside Down"
            case .LandscapeLeft: return "Landscape Left"
            case .LandscapeRight: return "Landscape Right"
            case .Unknown: return "Unknown"
            default: return ""
        }
    }
    
}

extension UINavigationController {
    
    override public func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .All
    }
    
}