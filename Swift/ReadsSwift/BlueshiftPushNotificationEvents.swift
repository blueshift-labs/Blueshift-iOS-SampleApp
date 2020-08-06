//
//  BlueshiftPushNotificationEvents.swift
//  ReadsSwift
//
//  Created by Ketan Shikhare on 22/07/20.
//

import Foundation
import BlueShift_iOS_SDK

class BlueshiftPushNotificationEvents: NSObject, BlueShiftPushDelegate {
    
    func handlePushAction(forIdentifier identifier: String!, withDetails details: [AnyHashable : Any]!) {
        //add logic to handle push action
        //Dont handle navigation here if the deep link navigation is already handled in appDelegate openURL
    }
}
