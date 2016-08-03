//
//  BluetoothOnOffViewController.swift
//  MoreSensorsExample
//
//  Created by Phu Nguyen Quang on 8/2/16.
//  Copyright © 2016 Phu Nguyen. All rights reserved.
//

import UIKit
import CoreBluetooth

//Define class variable in your VC/AppDelegate
var bluetoothPeripheralManager: CBPeripheralManager?

//On viewDidLoad/didFinishLaunchingWithOptions
let options = [CBCentralManagerOptionShowPowerAlertKey:0] //<-this is the magic bit!

class BluetoothOnOffViewController: UIViewController {

    @IBOutlet weak var lblBluetoothStatus: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bluetoothPeripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: options)
    }
    
    deinit {
        print("\(self) deinit")
    }

}

extension BluetoothOnOffViewController: CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        
        var statusMessage = ""
        
        switch peripheral.state {
        case CBPeripheralManagerState.PoweredOn:
            statusMessage = "Bluetooth Status: Turned On"
            lblBluetoothStatus.text = "ON"
            lblBluetoothStatus.textColor = UIColor.blueColor()
            
        case CBPeripheralManagerState.PoweredOff:
            statusMessage = "Bluetooth Status: Turned Off"
            lblBluetoothStatus.text = "OFF"
            lblBluetoothStatus.textColor = UIColor.redColor()
            
        case CBPeripheralManagerState.Resetting:
            statusMessage = "Bluetooth Status: Resetting"
            lblBluetoothStatus.text = "Resetting"
            lblBluetoothStatus.textColor = UIColor.darkGrayColor()
            
        case CBPeripheralManagerState.Unauthorized:
            statusMessage = "Bluetooth Status: Not Authorized"
            lblBluetoothStatus.text = "Not Authorized"
            lblBluetoothStatus.textColor = UIColor.redColor()
            
        case CBPeripheralManagerState.Unsupported:
            statusMessage = "Bluetooth Status: Not Supported"
            lblBluetoothStatus.text = "Not Supported"
            lblBluetoothStatus.textColor = UIColor.blackColor()
            
        default:
            statusMessage = "Bluetooth Status: Unknown"
            lblBluetoothStatus.text = "Unknown"
            lblBluetoothStatus.textColor = UIColor.blackColor()
        }
        
        print(statusMessage)
        
        if peripheral.state == CBPeripheralManagerState.PoweredOff {
            //TODO: Update this property in an App Manager class
        }
    }
    
}
