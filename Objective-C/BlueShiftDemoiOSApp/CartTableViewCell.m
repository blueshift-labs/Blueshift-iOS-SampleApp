//
//  CartTableViewCell.m
//  BlueShiftDemoiOSApp
//
//  Created by Shahas on 06/01/17.
//  Copyright © 2017 Arjun K P. All rights reserved.
//

#import "CartTableViewCell.h"
#import "UIView+BfViewHelpers.h"

@implementation CartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)deleteButtonDidPressed:(id)sender {
    [self.delegate removeButtonDidTapped:self.data];
}

- (void)setCartCell:(NSDictionary *)dictionary {
    self.data = dictionary;
    [self.cellView setBorderColour:[UIColor lightGrayColor] andBorderWidth:1.0];
    [self.cellView setCornerRadius:10.0];
    self.itemNameLabel.text = [dictionary objectForKey:@"name"];
    NSNumber *price = [NSNumber numberWithInt:[[dictionary objectForKey:@"price"] intValue]];
    NSNumber *quanity = [NSNumber numberWithInt:[[dictionary objectForKey:@"quantity"] intValue]];
    CGFloat totalPrice = [price floatValue] * [quanity integerValue];
    self.priceLabel.text = [NSString stringWithFormat:@"$ %.2f", totalPrice];
    self.taxLabel.text = [NSString stringWithFormat:@"$ %@", [dictionary objectForKey:@"tax"]];
    self.quantityLabel.text = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"quantity"]];
}

@end
