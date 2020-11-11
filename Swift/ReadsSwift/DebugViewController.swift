//
//  DebugViewController.swift
//  ReadsSwift
//
//  Created by Ketan Shikhare on 13/10/20.
//

import UIKit
import BlueShift_iOS_SDK

class DebugViewController: UIViewController {
        
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inAppRegisterSwitch: UISwitch!
    
    //To execute these push/in-app sends for testing, you will need to setup event based campaigns on basis of below "bsft_send_me_*" events. Then only this will work.
    let events: [[String:String]] = [["Send Slide-in in-app message":"bsft_send_me_in_app"],
                                     ["Send HTML in-app message":"bsft_send_me_in_app_html"],
                                     ["Send Modal in-app message":"bsft_send_me_in_app_modal"],
                                     ["Send Title+Content push notification":"bsft_send_me_push"],
                                     ["Send Image push notification":"bsft_send_me_image_push"],
                                     ["Send Animated Carousel push notification":"bsft_send_me_animated_carousel_push"],
                                     ["Send Non animated Carousel push notification":"bsft_send_me_nonanimated_carousel_push"]
                                    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        title = "Debug"
        inAppRegisterSwitch.isOn = false
    }

    @IBAction func fetchInApps(_ sender: Any) {
        BlueShift.sharedInstance()?.fetchInAppNotification(fromAPI: { }, failure: { (err) in
        })
    }
    @IBAction func registerForInApp(_ sender: Any) {
        guard let inAppSwitch = sender as? UISwitch else {
            return
        }
        if inAppSwitch.isOn {
            BlueShift.sharedInstance()?.registerFor(inAppMessage:  String(describing: type(of: self)))
        } else {
            BlueShift.sharedInstance()?.unregisterForInAppMessage()
        }
    }
}
extension DebugViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell:DebugTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DebugTableViewCellIdentifier", for: indexPath) as? DebugTableViewCell else {
            
            return UITableViewCell()
        }
        cell.titleLabel.text = events[indexPath.row].keys.first
        return cell
    }
}

extension DebugViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let event = events[indexPath.row].values.first {
            BlueShift.sharedInstance()?.trackEvent(forEventName: event, canBatchThisEvent: false)
        }
    }
}