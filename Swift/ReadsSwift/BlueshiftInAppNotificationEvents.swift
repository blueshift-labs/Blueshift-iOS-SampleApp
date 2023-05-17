//
//  BlueshiftInAppNotificationEvents.swift
//  ReadsSwift
//
//  Created by Ketan Shikhare on 22/07/20.
//

import Foundation
import BlueShift_iOS_SDK

class BlueshiftInAppNotificationEvents: NSObject, BlueShiftInAppNotificationDelegate {
    
//     Implementing this method will override the default behaviour of delivering deep-link to the OpenUrl method of the appDelegate and instead deep link will be delivered in this method.
//    func actionButtonDidTapped(_ notificationDictionary: [AnyHashable : Any]!) {
//        custom logic performed after clicking on in-app to be added here
//        if let notificationDictionary = notificationDictionary {
//            print("BlueshiftInAppNotificationEvents In App Clicked with details - ", notificationDictionary);
//        }
//    }
    
    func inAppNotificationDidOpen(_ payload: [AnyHashable : Any]!) {
//        print("inAppOpened \(String(describing: payload))")
    }
    
    func inAppNotificationDidDeliver(_ payload: [AnyHashable : Any]!) {
//        print("inAppDelivered \(String(describing: payload))")
    }
    
    func inAppNotificationDidClick(_ payload: [AnyHashable : Any]!) {
//        print("inAppClicked \(String(describing: payload))")
    }
}
