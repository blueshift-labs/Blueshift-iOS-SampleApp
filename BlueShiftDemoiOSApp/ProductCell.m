//
//  ProductCell.m
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 17/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import "ProductCell.h"

@implementation ProductCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setOption:(NSDictionary *)option {
    if(option == NULL) {
        return;
    }
    [self.productImageView setImage:[UIImage imageNamed:[option valueForKey:@"image"]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
