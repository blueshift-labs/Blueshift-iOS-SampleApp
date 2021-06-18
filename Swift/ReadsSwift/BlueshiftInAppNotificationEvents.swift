//
//  BlueshiftInAppNotificationEvents.swift
//  ReadsSwift
//
//  Created by Ketan Shikhare on 22/07/20.
//

import Foundation
import BlueShift_iOS_SDK

class BlueshiftInAppNotificationEvents: NSObject, BlueShiftInAppNotificationDelegate {
    
    func inAppNotificationWillAppear(_ notificationDictionary: [AnyHashable : Any]!) {
        //add custom logic here
    }

    func inAppNotificationDidAppear(_ notificationDictionary: [AnyHashable : Any]!) {
        //custom logic performed after displaying an in-app to be added here
    }
 
    func inAppNotificationWillDisappear(_ notificationDictionary: [AnyHashable : Any]!) {
        //add custom logic here
    }
    
    func inAppNotificationDidDisappear(_ notificationDictionary: [AnyHashable : Any]!) {
        //add custom logic here
    }
    
//    func actionButtonDidTapped(_ notificationDictionary: [AnyHashable : Any]!) {
        //custom logic performed after clicking on in-app to be added here
//        if let notificationDictionary = notificationDictionary {
//            print("BlueshiftInAppNotificationEvents In App Clicked with details - ", notificationDictionary);
//        }
//    }
    
    func inAppNotificationDidOpen(_ payload: [AnyHashable : Any]!) {
        print("inAppOpened \(String(describing: payload))")
    }
    
    func inAppNotificationDidDeliver(_ payload: [AnyHashable : Any]!) {
        print("inAppDelivered \(String(describing: payload))")
    }
    
    func inAppNotificationDidClick(_ payload: [AnyHashable : Any]!) {
        print("inAppClicked \(String(describing: payload))")
    }
}
