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
        if let details = details {
            print("BlueshiftPushNotificationEvents handlePushAction with details - ", details);
        }
    }
    
    func buyCategoryPushClicked(withDetails details: [AnyHashable : Any]!) {
        if let details = details {
            print("BlueshiftPushNotificationEvents buyCategoryPushClicked with details - ", details);
        }
    }
    
    func viewPushAction(withDetails details: [AnyHashable : Any]!) {
        if let details = details {
            print("BlueshiftPushNotificationEvents viewPushAction with details - ", details);
        }
    }
    
    func openCartPushAction(withDetails details: [AnyHashable : Any]!) {
        if let details = details {
            print("BlueshiftPushNotificationEvents openCartPushAction with details - ", details);
        }
    }
    
    //Callback for Dialogue box custom action
    func handleCustomCategory(_ categroyName: String!, clickedWithDetails details: [AnyHashable : Any]!) {
        if let details = details {
            print("BlueshiftPushNotificationEvents customCategory with name - \(categroyName ?? ""), details - ", details);
        }
    }
}
