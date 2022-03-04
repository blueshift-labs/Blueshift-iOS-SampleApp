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

        if BlueShiftPushNotification.sharedInstance()?.isBlueShiftPushNotification(request) == true, let attachments = BlueShiftPushNotification.sharedInstance()?.integratePushNotificationWithMediaAttachements(for: request, andAppGroupID: nil) as? [UNNotificationAttachment] {
            bestAttemptContent?.attachments = attachments
        } else {
            //handle notifications if not from Blueshift
        }
        // Define the custom actions.
        if let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        if let attachments = BlueShiftPushNotification.sharedInstance()?.attachments {
            bestAttemptContent?.attachments = attachments
        } else {
            //handle notifications if not from Blueshift
        }
        if let bestAttemptContent = bestAttemptContent, let contentHandler = contentHandler {
            contentHandler(bestAttemptContent)
        }
    }
}
