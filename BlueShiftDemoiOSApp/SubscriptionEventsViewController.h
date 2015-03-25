//
//  SubscriptionEventsViewController.h
//  BlueShiftDemoiOSApp
//
//  Created by Arjun K P on 12/03/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BlueShift-iOS-SDK/BlueShift.h>

@interface SubscriptionEventsViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property IBOutlet UIPickerView *subscriptionTypePickerView;
@property NSArray *subscriptionTypes;

@property NSString *currentSubscription;
@property NSString *cycleType;
@property NSInteger cycleLength;
@property float price;

- (IBAction)initializeButtonPressed:(id)sender;
- (IBAction)pauseButtonPressed:(id)sender;
- (IBAction)unPauseButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;

@end
