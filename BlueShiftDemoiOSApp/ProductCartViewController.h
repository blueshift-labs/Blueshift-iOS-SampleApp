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
#import "BaseViewController.h"
#import "CartDelegate.h"

@interface ProductCartViewController : BaseViewController<BlueShiftPushDelegate, CartDelegate>

// NSLayout Constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeightConstraint;

// UIViews
@property (weak, nonatomic) IBOutlet UIView *priceView;
@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UIView *cartEmptyView;

// UITableView
@property (weak, nonatomic) IBOutlet UITableView *itemsTableView;


// UILabels
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *taxLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippingChargeLabel;
@property (weak, nonatomic) IBOutlet UILabel *finalTotalLabel;

// UITextField
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *pinTextField;

// Properties
@property NSArray *products;


- (IBAction)continueButtonPressed:(id)sender;

@end
