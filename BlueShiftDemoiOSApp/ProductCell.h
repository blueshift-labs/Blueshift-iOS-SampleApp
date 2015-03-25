//
//  ProductCell.h
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 17/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCell : UITableViewCell

@property IBOutlet UIImageView *productImageView;

- (void)setOption:(NSDictionary*)option;

@end
