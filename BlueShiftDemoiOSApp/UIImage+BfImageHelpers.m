//
//  UIImage+BfImageHelpers.m
//  Delivery-iOS
//
//  Created by Apple on 9/5/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import "UIImage+BfImageHelpers.h"

@implementation UIImage (BfImageHelpers)
+(UIImage*) tiledImage {
    UIEdgeInsets redLine = UIEdgeInsetsMake(0, 15, 0, 34);
    UIImage *stretchableImage = [[UIImage imageNamed:@"placeHolderImageTile.png"] resizableImageWithCapInsets:redLine resizingMode:UIImageResizingModeTile];

    return stretchableImage;
}
@end
