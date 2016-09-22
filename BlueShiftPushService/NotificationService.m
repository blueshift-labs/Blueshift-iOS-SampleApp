//
//  NotificationService.m
//  BlueShiftPushService
//
//  Created by Shahas on 20/09/16.
//  Copyright © 2016 Arjun K P. All rights reserved.
//

#import "NotificationService.h"
#import <BlueShift-iOS-SDK/BlueShiftPushNotification.h>

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // Modify the notification content here...
    self.bestAttemptContent.attachments = [[BlueShiftPushNotification sharedInstance] integratePushNotificationWithMediaAttachementsForRequest:request];
    
    self.contentHandler(self.bestAttemptContent);
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
