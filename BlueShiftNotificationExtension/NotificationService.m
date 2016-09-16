//
//  NotificationService.m
//  BlueShiftNotificationExtension
//
//  Created by Shahas on 15/09/16.
//  Copyright © 2016 Arjun K P. All rights reserved.
//

#import "NotificationService.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // Modify the notification content here...
    //self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", @"shahas"];
    NSURL *url = [NSURL URLWithString:[request.content.userInfo objectForKey:@"my-attachment"]];
    NSData *data = [[NSData alloc] initWithContentsOfURL: url];
    if (data)
    {
        NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString  *documentsDirectory = [paths objectAtIndex:0];
        
        
        
        NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
        // NSTimeInterval is defined as double
        NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
        NSString *imageName = [NSString stringWithFormat:@"image_%@", timeStampObj];
        
        NSURL *baseURL = [NSURL fileURLWithPath:documentsDirectory];
        NSURL *URL = [NSURL URLWithString:imageName relativeToURL:baseURL];
        
        NSString  *filePath = [URL absoluteString];
        [data writeToFile:filePath atomically:YES];
        NSError *error3;
        UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:imageName URL:URL options:nil error:&error3];
        NSLog(@"%@", error3);
        self.bestAttemptContent.attachments = @[attachment];
        self.contentHandler(self.bestAttemptContent);
    }
    

    
    
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
