//
//  NotificationService.m
//  BlueShiftNotificationExtension
//
//  Created by Shahas on 15/09/16.
//  Copyright © 2016 Arjun K P. All rights reserved.
//

#import "NotificationService.h"
#import <BlueShift-iOS-SDK/BlueShift.h>

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    [[BlueShiftPushNotification sharedInstance] integratePushNotificationWithMediaAttachementsForRequest:request withContentHandler:contentHandler];
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
