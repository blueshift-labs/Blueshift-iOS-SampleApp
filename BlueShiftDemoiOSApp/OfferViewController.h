//
//  OfferViewController.h
//  BlueShiftDemoiOSApp
//
//  Created by Arjun K P on 12/03/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BlueShift-iOS-SDK/BlueShift.h>

@interface OfferViewController : UIViewController<BlueShiftPushParamDelegate>

@property IBOutlet UIImageView *offerImageView;
@property NSString *imageURL;

@end
