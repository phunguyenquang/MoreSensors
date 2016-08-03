//
//  ScreenOnOffViewController.swift
//  MoreSensorsExample
//
//  Created by Phu Nguyen Quang on 8/1/16.
//  Copyright © 2016 Phu Nguyen. All rights reserved.
//

import UIKit

class ScreenOnOffViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var displayStatusChanged: CFNotificationCallback!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayStatusChanged = { (center: CFNotificationCenter!, observer, name: CFString!, object, userInfo: CFDictionary!)  in
            
            // because it's too difficult to convert self to C pointer type and vice versa, we should you variable in app delegate instead
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let eventName = name
            
            /*if eventName == "com.apple.springboard.hasBlankedScreen" {
                print("screen blank")
                appDelegate.isDeviceLocked = false
            } else*/
            if eventName == "com.apple.springboard.lockcomplete" {
                print("lock!")
                appDelegate.isDeviceLocked = true
            } else if eventName == "com.apple.springboard.lockstate" {
                if appDelegate.isDeviceLocked {
                    print("device is locked\n")
                } else {
                    print("device is unlocked\n")
                }
                let screenLocked = ScreenLock(isLocked: appDelegate.isDeviceLocked, datetime: NSDate())
                appDelegate.screenLockLog.append(screenLocked)
                appDelegate.reloadScreenLockTableView()
                
            }
        }
        
        addNotificationObserver()
    }
    
    deinit {
        print("\(self) deinit")
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Public method
    
    func reloadTableViewData() {
        tableView.reloadData()
    }
    
    // MARK: - Notification handler
    
    func appDidEnterBackground() {
        print("app did enter background\n")
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if appDelegate.isDeviceLocked {
            appDelegate.isDeviceLocked = false
        }
    }
    
    // MARK: - Private method
    
    func addNotificationObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplicationDidEnterBackgroundNotification, object: nil)
        
        /*CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), nil, displayStatusChanged, "com.apple.springboard.hasBlankedScreen", nil, CFNotificationSuspensionBehavior.DeliverImmediately)*/
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), nil, displayStatusChanged, "com.apple.springboard.lockcomplete", nil, CFNotificationSuspensionBehavior.DeliverImmediately)
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), nil, displayStatusChanged, "com.apple.springboard.lockstate", nil, CFNotificationSuspensionBehavior.DeliverImmediately)
    }

}

extension ScreenOnOffViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.screenLockLog.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: "ScreenLockCell")
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let screenLock = appDelegate.screenLockLog[indexPath.row]
        let screenLockString = screenLock.isLocked == true ? "ON" : "OFF"
        
        cell.textLabel?.text = "Screen \(screenLockString)"
        cell.detailTextLabel?.text = String(screenLock.datetime)
        return cell
    }
    
}
