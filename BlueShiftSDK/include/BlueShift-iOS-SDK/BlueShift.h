//
//  BlueShift.h
//  BlueShift
//
//  Created by Asif on 2/16/15.
//  Copyright (c) 2015 Bullfinch Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlueShiftConfig.h"
#import "BlueShiftDeviceData.h"
#import "BlueShiftAppDelegate.h"
#import "BlueShiftPushDelegate.h"
#import "BlueShiftDeepLink.h"
#import "BlueShiftPushParamDelegate.h"

@class BlueShiftDeviceData;
//@protocol BlueShiftPushDelegate;

@interface BlueShift : NSObject

@property (nonatomic, strong) BlueShiftConfig *config;
@property BlueShiftDeviceData *deviceData;
@property NSString *deviceToken;
//@property (nonatomic, copy) void (^customizedDeepLinkHandler)(void);

+ (instancetype)sharedInstance;
+ (void) initWithConfiguration:(BlueShiftConfig *)config;
- (void) setPushDelegate: (id) obj;
- (void) setPushParamDelegate: (id) obj;
- (NSString *) getDeviceToken;

@end
