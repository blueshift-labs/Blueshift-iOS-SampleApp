//
//  NotificationService.swift
//  NotificationService
//
//  Created by Ketan on 20/05/20.
//

import UserNotifications
import BlueShift_iOS_Extension_SDK

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        BlueShiftPushNotification.sharedInstance()?.apiKey = "5dfe3c9aee8b375bcc616079b08156d9"
        
        var appGroupID = ""
        if Bundle.main.bundleIdentifier == "com.blueshift.reads" {
            appGroupID = "group.blueshift.reads"
        } else {
            appGroupID = "group.blueshift.reads.red"
        }

        if BlueShiftPushNotification.sharedInstance()?.isBlueShiftPushNotification(request) == true, let attachments = BlueShiftPushNotification.sharedInstance()?.integratePushNotificationWithMediaAttachements(for: request, andAppGroupID: appGroupID) as? [UNNotificationAttachment] {
            bestAttemptContent?.attachments = attachments
        } else {
            //other
        }
        if let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
        if let attachments = BlueShiftPushNotification.sharedInstance()?.attachments {
            bestAttemptContent?.attachments = attachments
        } else {
            //other
        }
        if let bestAttemptContent = bestAttemptContent, let contentHandler = contentHandler {
            contentHandler(bestAttemptContent)
        }
    }
}
