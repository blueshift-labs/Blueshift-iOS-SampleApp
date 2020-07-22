//
//  CartDelegate.h
//  BlueShiftDemoiOSApp
//
//  Created by Shahas on 10/01/17.
//  Copyright © 2017 Arjun K P. All rights reserved.
//

#ifndef CartDelegate_h
#define CartDelegate_h

@protocol CartDelegate <NSObject>

@optional
- (void) removeButtonDidTapped:(NSDictionary *)item;
@end

#endif /* CartDelegate_h */
