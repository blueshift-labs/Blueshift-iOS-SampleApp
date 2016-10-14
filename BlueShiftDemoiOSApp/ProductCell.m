//
//  ProductCell.m
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 17/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import "ProductCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+BfImageHelpers.h"


@implementation ProductCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0,10,100,100);
    //self.imageView.frame =
}

- (void)setOption:(NSDictionary *)option {
    if(option == NULL) {
        return;
    }
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[option objectForKey:@"image_url"]] placeholderImage:[UIImage imageNamed:@"BookPlaceholder"]];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.titleLabel.text = [option objectForKey:@"name"];
    self.priceLabel.text = [option objectForKey:@"price"];
    self.imageView.layer.cornerRadius = 10;
    self.imageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
