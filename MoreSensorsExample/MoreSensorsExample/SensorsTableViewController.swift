//
//  SensorsTableViewController.swift
//  MoreSensorsExample
//
//  Created by Phu Nguyen Quang on 7/27/16.
//  Copyright © 2016 Phu Nguyen. All rights reserved.
//

import UIKit

class SensorsTableViewController: UITableViewController {

    struct AvailableSensorIndex {
        static let MICROPHONE_NOISE_LEVEL = 2
        static let SCREEN_ON_OFF = 3
        static let PHONE_CALL = 4
        static let SCREEN_ROTATION_CHANGE = 10
        static let HEADPHONE_PLUGGED = 11
        static let MUSIC_PLAYED = 12
        static let SILENT_MODE = 15
        static let BLUETOOTH = 17
        static let LOCATION_TRACKING = 18
    }
    
    let sensors = [
        Sensor(name: "temperature", ableToDetect: false, description: "Get ambient temperature from iPhone"),
        Sensor(name: "humidity", ableToDetect: false, description: "Get ambient humidity from iPhone"),
        Sensor(name: "microphone noise level", ableToDetect: true, description: "Get microphone volume from iPhone"),
        Sensor(name: "screen on / off", ableToDetect: true, description: "Detect if screen on/off"),
        Sensor(name: "phone call starts/stops", ableToDetect: true, description: "Get network, carrier info. Get phone call statuses: incoming, dealing, connected, disconnected"),
        Sensor(name: "OTT apps call", ableToDetect: false, description: "FaceTime/Whatsapp/Skype/Viber etc. calls"),
        Sensor(name: "data transfer rate", ableToDetect: false, description: "Get internet speed of device"),
        Sensor(name: "which app is in foreground", ableToDetect: false, description: "Detect to see which app is running in foreground"),
        Sensor(name: "pressing any hardware button", ableToDetect: false, description: "Detect to see if user pressing any hardware button"),
        Sensor(name: "track activities on lock screen", ableToDetect: false, description: "Track user’s activities on lock screen like touch ID/enter passcode/take photo…"),
        Sensor(name: "screen rotation (4 values)", ableToDetect: true, description: "Detect screen rotation changes within app"),
        Sensor(name: "head phone plugged in (plug in / plug out)", ableToDetect: true, description: "Detect if user plugs in/out headphone to the phone"),
        Sensor(name: "playing music (start / stop)", ableToDetect: true, description: "Detect if iDevice playing any kind of audio, not only music"),
        Sensor(name: "take a picture", ableToDetect: false, description: "Detect if iDevice take a picture"),
        Sensor(name: "record a video (start / stop)", ableToDetect: false, description: "Detect if iDevice record a video"),
        Sensor(name: "phone sound profile (silent / sound)", ableToDetect: true, description: "Detect if user turns on/off silent mode"),
        Sensor(name: "do not disturb mode on / off", ableToDetect: false, description: "Detect if user turns on/off “Do not disturb” mode"),
        Sensor(name: "bluetooth on / off", ableToDetect: true, description: "Detect if user turns on/off bluetooth"),
        Sensor(name: "location tracking on / off", ableToDetect: true, description: "Detect if user turns on/off location tracking of the app"),
        Sensor(name: "user is typing, soft keyboard is shown", ableToDetect: false, description: "Detect if user is typing, soft keyboard is shown")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sensors.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "SensorCell")
//        let cell = tableView.dequeueReusableCellWithIdentifier("SensorCell", forIndexPath: indexPath)
        let sensor = sensors[indexPath.row]

        cell.textLabel?.text = sensor.name
        cell.textLabel?.textColor = sensor.ableToDetect ? UIColor.blackColor() : UIColor.lightGrayColor()
        cell.detailTextLabel?.text = sensor.description
        cell.detailTextLabel?.textColor = sensor.ableToDetect ? UIColor.blackColor() : UIColor.lightGrayColor()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
            case AvailableSensorIndex.MICROPHONE_NOISE_LEVEL:   performSegueWithIdentifier("MicrophoneVolume", sender: nil)
            case AvailableSensorIndex.SCREEN_ON_OFF:            performSegueWithIdentifier("ScreenOnOff", sender: nil)
            case AvailableSensorIndex.PHONE_CALL:               performSegueWithIdentifier("PhoneCall", sender: nil)
            case AvailableSensorIndex.SCREEN_ROTATION_CHANGE:   performSegueWithIdentifier("ScreenRotationChange", sender: nil)
            case AvailableSensorIndex.HEADPHONE_PLUGGED:        performSegueWithIdentifier("HeadphonePlugging", sender: nil)
            case AvailableSensorIndex.MUSIC_PLAYED:             performSegueWithIdentifier("AudioPlaying", sender: nil)
            case AvailableSensorIndex.SILENT_MODE:              performSegueWithIdentifier("SilentMode", sender: nil)
            case AvailableSensorIndex.BLUETOOTH:                performSegueWithIdentifier("BluetoothOnOff", sender: nil)
            case AvailableSensorIndex.LOCATION_TRACKING:        performSegueWithIdentifier("LocationOnOff", sender: nil)
            default: break
            
        }
    }
    
    

}
