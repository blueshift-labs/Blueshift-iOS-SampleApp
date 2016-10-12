//
//  SideMenuCell.m
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 12/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import "SideMenuCell.h"

@implementation SideMenuCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setOption:(NSDictionary *)option {
    if(option == NULL) {
        return;
    }
    self.optionTitle.text = [option valueForKey:@"title"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
