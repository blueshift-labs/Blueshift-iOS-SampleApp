//
//  BaseViewController.h
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 12/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+BfViewHelpers.h"
#import <BlueShift-iOS-SDK/BlueShift.h>

@protocol BaseViewControllerDelegate <NSObject>

@optional
-(void)viewDidLoadIfDeviceLessThanOrEqualToIPhone5;

@end

@interface BaseViewController : UIViewController<BaseViewControllerDelegate>

@property (nonatomic,retain) id<BaseViewControllerDelegate> baseViewControllerDelegate;
@property UIColor *borderColor;

//- (void)toggleLeftViewAnimated:(BOOL)animated;
- (void)setNavigationBarTitle:(NSString *)title;
- (void)pushCartPage;

@end
