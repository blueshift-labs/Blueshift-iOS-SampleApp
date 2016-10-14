//
//  ProductDetailViewController.h
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 17/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BlueShift-iOS-SDK/BlueShift.h>

@interface ProductDetailViewController : UIViewController<BlueShiftPushDelegate, UIGestureRecognizerDelegate>

@property NSDictionary *data;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *skuLabel;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *quantityButton;

- (IBAction)buyButtonPressed:(id)sender;
- (IBAction)quantityButtonDidPressed:(id)sender;
- (IBAction)addToCartButtonDidPressed:(id)sender;

@end
