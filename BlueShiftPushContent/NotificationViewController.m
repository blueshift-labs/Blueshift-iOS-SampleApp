//
//  NotificationViewController.m
//  BlueShiftPushContent
//
//  Created by Shahas on 21/09/16.
//  Copyright © 2016 Arjun K P. All rights reserved.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface NotificationViewController () <UNNotificationContentExtension>

@property IBOutlet UILabel *label;
@property IBOutlet UIImageView *imageView;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.
}

- (void)didReceiveNotification:(UNNotification *)notification {

    /*
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,self.view.frame.size.width - 60 , self.view.frame.size.height - 60)];
    [self.view addSubview:backgroundImage];
    
    NSURL *imageURL = [NSURL URLWithString:[notification.request.content.userInfo objectForKey:@"image_url"]];
    
    NSData *imageData = nil;
    
    if(imageURL != nil) {
        imageData = [[NSData alloc] initWithContentsOfURL: imageURL];
        UIImage *image = [UIImage imageWithData:imageData];
        backgroundImage.image = image;
    }
    */
    
    UNNotificationAttachment *attachment = notification.request.content.attachments.firstObject;
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,self.view.frame.size.width - 20 , self.view.frame.size.height - 20)];
    backgroundImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:backgroundImage];
    
    if (attachment.URL.startAccessingSecurityScopedResource) {
        UIImage *image = [UIImage imageWithContentsOfFile:attachment.URL.path];
        backgroundImage.image = image;
    }
    
}

@end
