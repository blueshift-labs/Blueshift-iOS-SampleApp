//
//  ProductDetailViewController.h
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 17/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BlueShift-iOS-SDK/BlueShift.h>

@interface ProductDetailViewController : UIViewController<BlueShiftPushDelegate>

- (IBAction)buyButtonPressed:(id)sender;

@end
