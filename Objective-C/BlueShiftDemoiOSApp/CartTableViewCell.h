//
//  CartTableViewCell.h
//  BlueShiftDemoiOSApp
//
//  Created by Shahas on 06/01/17.
//  Copyright © 2017 Arjun K P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCartViewController.h"
#import "CartDelegate.h"

@interface CartTableViewCell : UITableViewCell

// UIView
@property (weak, nonatomic) IBOutlet UIView *cellView;

// UILabels
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *taxLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

// Members
@property NSDictionary *data;
@property (nonatomic,retain) id<CartDelegate> delegate;

- (IBAction)deleteButtonDidPressed:(id)sender;


- (void)setCartCell:(NSDictionary *)dictionary;


@end
