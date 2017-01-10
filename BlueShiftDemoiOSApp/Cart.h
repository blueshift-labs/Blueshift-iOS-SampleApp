//
//  Cart.h
//  BlueShiftDemoiOSApp
//
//  Created by Shahas on 06/01/17.
//  Copyright © 2017 Arjun K P. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cart : NSObject

+ (NSArray*)sharedInstance;
+ (void)addToCard:(NSDictionary *)dictionary;
+ (void)removeFromCart:(NSDictionary *)dictionary;
+ (NSArray *)fetchProducts;
+ (NSDictionary *)fetchProduct:(NSString *)sku;
+ (void)clearCart;

@end
