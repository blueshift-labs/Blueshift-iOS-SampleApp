//
//  BlueshiftPushNotificationEvents.swift
//  ReadsSwift
//
//  Created by Ketan Shikhare on 22/07/20.
//

import Foundation
import BlueShift_iOS_SDK

class BlueshiftPushNotificationEvents: NSObject, BlueShiftPushDelegate {
    
    func handleCarouselPush(forCategory categoryName: String, clickedWith index: Int, withDetails details: [AnyHashable : Any]) {
//        if let details = details {
//            print("Carousel Push notification clicked ", details);
//        }
    }
    func pushNotificationDidClick(_ payload: [AnyHashable : Any]?) {
//        if let details = payload {
//            print("Push notification clicked ", details);
//        }
    }
    
    func pushNotificationDidClick(_ payload: [AnyHashable : Any]?, forActionIdentifier identifier: String?) {
//        if let details = payload {
//            print("Push notification with action clicked ", details);
//        }
    }
}
