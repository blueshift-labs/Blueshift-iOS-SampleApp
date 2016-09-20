//
//  NotificationService.m
//  BlueShiftPushService
//
//  Created by Shahas on 19/09/16.
//  Copyright © 2016 Arjun K P. All rights reserved.
//

#import "NotificationService.h"
//#import <BlueShift-iOS-SDK/BlueShift.h>

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // Modify the notification content here...
    self.bestAttemptContent.attachments = [self integratePushNotificationWithMediaAttachementsForRequest:request];
    self.contentHandler(self.bestAttemptContent);
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

- (NSArray *)integratePushNotificationWithMediaAttachementsForRequest:(UNNotificationRequest *)request {
    
    NSURL *imageURL = [NSURL URLWithString:[request.content.userInfo objectForKey:@"image_url"]];
    NSURL *videoURL = [NSURL URLWithString:[request.content.userInfo objectForKey:@"video_url"]];
    NSURL *audioURL = [NSURL URLWithString:[request.content.userInfo objectForKey:@"audio_url"]];
    NSURL *gifURL   = [NSURL URLWithString:[request.content.userInfo objectForKey:@"gif_url"]];

    NSData *imageData = nil;
    NSData *videoData = nil;
    NSData *audioData = nil;
    NSData *gifData   = nil;
    
    NSMutableArray *attachments = [[NSMutableArray alloc]init];
    
    if(imageURL != nil) {
        imageData = [[NSData alloc] initWithContentsOfURL: imageURL];
        if(imageData) {
            NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString  *documentsDirectory = [paths objectAtIndex:0];
            
            NSString *attachmentName = [NSString stringWithFormat:@"image.jpg"];
            NSURL *baseURL = [NSURL fileURLWithPath:documentsDirectory];
            NSURL *URL = [NSURL URLWithString:attachmentName relativeToURL:baseURL];
            NSString  *filePathToWrite = [NSString stringWithFormat:@"%@/%@", documentsDirectory, attachmentName];
            [imageData writeToFile:filePathToWrite atomically:YES];
            
            NSError *error3;
            UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:attachmentName URL:URL options:nil error:&error3];
            NSLog(@"%@", error3);
            if(attachment != nil) {
                [attachments addObject:attachment];
            }
        }
    }
    if(videoURL != nil) {
        videoData = [[NSData alloc] initWithContentsOfURL: videoURL];
        if(videoData) {
            NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString  *documentsDirectory = [paths objectAtIndex:0];
            
            NSString *attachmentName = [NSString stringWithFormat:@"video.mp4"];
            NSURL *baseURL = [NSURL fileURLWithPath:documentsDirectory];
            NSURL *URL = [NSURL URLWithString:attachmentName relativeToURL:baseURL];
            NSString  *filePathToWrite = [NSString stringWithFormat:@"%@/%@", documentsDirectory, attachmentName];
            [videoData writeToFile:filePathToWrite atomically:YES];
            
            NSError *error3;
            UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:attachmentName URL:URL options:nil error:&error3];
            NSLog(@"%@", error3);
            if(attachment != nil) {
                [attachments addObject:attachment];
            }
        }
    }
    if(gifURL != nil) {
        gifData = [[NSData alloc] initWithContentsOfURL: gifURL];
        if(gifData) {
            NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString  *documentsDirectory = [paths objectAtIndex:0];
            
            NSString *attachmentName = [NSString stringWithFormat:@"gifImage.gif"];
            NSURL *baseURL = [NSURL fileURLWithPath:documentsDirectory];
            NSURL *URL = [NSURL URLWithString:attachmentName relativeToURL:baseURL];
            NSString  *filePathToWrite = [NSString stringWithFormat:@"%@/%@", documentsDirectory, attachmentName];
            [gifData writeToFile:filePathToWrite atomically:YES];
            
            NSError *error3;
            UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:attachmentName URL:URL options:nil error:&error3];
            NSLog(@"%@", error3);
            if(attachment != nil) {
                [attachments addObject:attachment];
            }
        }
    }
    if(audioURL != nil) {
        audioData = [[NSData alloc] initWithContentsOfURL: audioURL];
        if(audioData) {
            NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString  *documentsDirectory = [paths objectAtIndex:0];
            
            NSString *attachmentName = [NSString stringWithFormat:@"audio.mp3"];
            NSURL *baseURL = [NSURL fileURLWithPath:documentsDirectory];
            NSURL *URL = [NSURL URLWithString:attachmentName relativeToURL:baseURL];
            NSString  *filePathToWrite = [NSString stringWithFormat:@"%@/%@", documentsDirectory, attachmentName];
            [audioData writeToFile:filePathToWrite atomically:YES];
            
            NSError *error3;
            UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:attachmentName URL:URL options:nil error:&error3];
            NSLog(@"%@", error3);
            if(attachment != nil) {
                [attachments addObject:attachment];
            }
        }
    }
    return attachments;
}


@end
