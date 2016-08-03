//
//  LocationOnOffViewController.swift
//  MoreSensorsExample
//
//  Created by Phu Nguyen Quang on 8/2/16.
//  Copyright © 2016 Phu Nguyen. All rights reserved.
//

import UIKit
import CoreLocation
import PermissionScope

class LocationOnOffViewController: UIViewController {

    @IBOutlet weak var lblLocationStatus: UILabel!
    
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.delegate = self
    }
    
    deinit {
        print("\(self) deinit")
    }

}

extension LocationOnOffViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch status {
            
            case .Denied:
                lblLocationStatus.text = "OFF"
                lblLocationStatus.textColor = UIColor.redColor()
                
            case .AuthorizedAlways, .AuthorizedWhenInUse:
                lblLocationStatus.text = "ON"
                lblLocationStatus.textColor = UIColor.blueColor()
                
            case .NotDetermined:
                lblLocationStatus.text = "Not Determined"
                lblLocationStatus.textColor = UIColor.blackColor()
                
            case .Restricted:
                lblLocationStatus.text = "Restricted"
                lblLocationStatus.textColor = UIColor.redColor()
            
        }
        
    }
    
}
