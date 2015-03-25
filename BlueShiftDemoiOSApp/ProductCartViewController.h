//
//  ProductCartViewController.h
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 17/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BlueShift-iOS-SDK/BlueShift.h>
#import "ProductOrderCompletedViewController.h"

@interface ProductCartViewController : UIViewController<BlueShiftPushDelegate>

@property NSArray *productsArray;

- (IBAction)continueButtonPressed:(id)sender;

@end
