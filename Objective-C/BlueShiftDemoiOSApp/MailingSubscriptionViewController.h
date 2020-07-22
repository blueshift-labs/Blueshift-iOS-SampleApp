//
//  MailingSubscriptionViewController.h
//  BlueShiftDemoiOSApp
//
//  Created by Arjun K P on 12/03/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttributedTextField.h"
#import <BlueShift-iOS-SDK/BlueShift.h>

@interface MailingSubscriptionViewController : UIViewController

@property IBOutlet AttributedTextField *emailTextField;

- (IBAction)subscribeMailingListPressed:(id)sender;
- (IBAction)unSubscribeMailingListPressed:(id)sender;

@end
