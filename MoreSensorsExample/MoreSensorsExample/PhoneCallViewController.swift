//
//  PhoneCallViewController.swift
//  MoreSensorsExample
//
//  Created by Phu Nguyen Quang on 7/25/16.
//  Copyright © 2016 Phu Nguyen. All rights reserved.
//

import UIKit
import CoreTelephony

/* Call statuses:
 - dial then cancelled by myself: Dialing -> Disconnected
 - dial then cancelled by someone: Dialing -> Disconnected
 - dial then no response: Dialing -> Disconnected
 - dial then have response: Dialing -> Connected -> Disconnected
 - incoming call then cancel by myself: Incoming -> Disconnected
 - incoming call then cancel by someone (missed call): Incoming -> Disconnected
 - incoming call then no response: Incoming -> Disconnected
 - incoming call then have response: Incoming -> Connected -> Disconnected
 */

class PhoneCallViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var callCenter = CTCallCenter()
    private var callWasStarted = false
    private var carrier: CTCarrier?
    private var loggedCalls = [CTCall]()
    private let networkInfo = CTTelephonyNetworkInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNetworkInfo()
        
        callCenter.callEventHandler = { [unowned self] (call: CTCall) in
            print(call)
            self.loggedCalls.append(call)
            self.tableView.reloadData()
        }
    }
    
    deinit {
        print("\(self) deinit")
    }

    // MARK: - Action
    
    @IBAction func callANumber(sender: UIBarButtonItem) {
        
        if carrier?.mobileCountryCode != nil {
            if let phoneUrl = NSURL(string: String("telprompt://01673703097")) {
                if UIApplication.sharedApplication().canOpenURL(phoneUrl) {
                    UIApplication.sharedApplication().openURL(phoneUrl)
                }
            }
        } else {
            print("no sim card")
            let alert = UIAlertController(title: "No SIM Card", message: "", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - General
    
    private func getNetworkInfo() {
        if let subscriberCellularProvider = networkInfo.subscriberCellularProvider {
            carrier = subscriberCellularProvider
            print("carrier: \(carrier)")
        }
        print("Radio Access Technology: \(networkInfo.currentRadioAccessTechnology)")
    }

}

extension PhoneCallViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "ℹ️ Carrier information"
        } else {
            return "📞 Call status log (from this app)"
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 6
        } else {
            return loggedCalls.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "PhoneCallCell")
        
        if indexPath.section == 0 {
            
            switch indexPath.row {
                case 0:
                    cell.textLabel?.text = "Carrier name"
                    cell.detailTextLabel?.text = (carrier != nil ? carrier!.carrierName : "")
                case 1:
                    cell.textLabel?.text = "Mobile Country Code"
                    cell.detailTextLabel?.text = (carrier != nil ? carrier!.mobileCountryCode : "")
                case 2:
                    cell.textLabel?.text = "Mobile Network Code"
                    cell.detailTextLabel?.text = (carrier != nil ? carrier!.mobileNetworkCode : "")
                case 3:
                    cell.textLabel?.text = "ISO Country Code"
                    cell.detailTextLabel?.text = (carrier != nil ? carrier!.isoCountryCode : "")
                case 4:
                    cell.textLabel?.text = "Allows VOIP?"
                    cell.detailTextLabel?.text = (carrier != nil ? String(carrier!.allowsVOIP) : "")
                case 5:
                    cell.textLabel?.text = "Radio Access Technology"
                    cell.detailTextLabel?.text = networkInfo.currentRadioAccessTechnology ?? ""
                default: break
            }
            
        } else {
            let call = loggedCalls[indexPath.row]
            cell.textLabel?.text = call.callID
            cell.detailTextLabel?.text = call.callState
        }
        
        return cell
    }
}
