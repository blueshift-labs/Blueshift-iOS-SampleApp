//
//  NotificationViewController.swift
//  NotificationContent
//
//  Created by Ketan on 21/05/20.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import BlueShift_iOS_Extension_SDK

class NotificationViewController: BlueShiftCarousalViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Bundle.main.bundleIdentifier == "com.blueshift.reads" {
            appGroupID = "group.blueshift.reads"
        } else {
            appGroupID = "group.blueshift.reads.red"
        }
    }
    
    func didReceive(_ notification: UNNotification) {
        if isBlueShiftCarouselPush(notification) {
            showCarousel(forNotfication: notification)
        } else {
            //other
        }
    }

    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        if isBlueShiftCarouselActions(response) {
            setCarouselActionsFor(response) { (option) in
                completion(option)
            }
        } else {
            //other
        }
    }
}
