//
//  HomeViewController.h
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 12/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "AppConstants.h"
#import "SegueIdentifiers.h"
#import <BlueShift-iOS-SDK/BlueShift.h>

@interface HomeViewController : BaseViewController<BaseViewControllerDelegate>

@property IBOutlet UIView *contentView;
@property IBOutlet NSLayoutConstraint *contentViewWidthConstraint;

@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
- (IBAction)productsButtonPressed:(id)sender;
- (IBAction)cancelReturnButtonPressed:(id)sender;
- (IBAction)mailingListSubscriptionButtonPressed:(id)sender;
- (IBAction)subscriptionEventsButtonPressed:(id)sender;
- (IBAction)logoutButtonDidPressed:(id)sender;

@end
