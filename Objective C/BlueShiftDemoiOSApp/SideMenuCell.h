//
//  SideMenuCell.h
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 12/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideMenuCell : UITableViewCell

@property IBOutlet UILabel *optionTitle;


- (void)setOption:(NSDictionary*)option;

@end
