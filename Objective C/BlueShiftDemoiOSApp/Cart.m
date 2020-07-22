//
//  Cart.m
//  BlueShiftDemoiOSApp
//
//  Created by Shahas on 06/01/17.
//  Copyright © 2017 Arjun K P. All rights reserved.
//

#import "Cart.h"

static NSArray *_sharedInstance = NULL;

@implementation Cart

+ (NSArray*)sharedInstance {
    if(_sharedInstance == NULL) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [defaults objectForKey:@"cartItems"];
        NSArray<NSDictionary *> *cartItems = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if(cartItems != NULL) {
            _sharedInstance = cartItems;
        } else {
            _sharedInstance = [[NSArray alloc] init];
        }
    }
    return _sharedInstance;
}

+ (void)addToCard:(NSDictionary *)dictionary {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray<NSDictionary *> *cartItems = [_sharedInstance mutableCopy];
    for (NSMutableDictionary *item in cartItems) {
        if([[item objectForKey:@"sku"] isEqualToString:[dictionary objectForKey:@"sku"]]) {
            [cartItems removeObject:item];
            break;
        }
    }
    [cartItems addObject:dictionary];
    _sharedInstance = cartItems;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cartItems];
    [defaults setObject:data forKey:@"cartItems"];
    [defaults synchronize];
}

+ (void)removeFromCart:(NSDictionary *)dictionary {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray<NSDictionary *> *cartItems = [_sharedInstance mutableCopy];
    for (NSMutableDictionary *item in cartItems) {
        if([[item objectForKey:@"sku"] isEqualToString: [dictionary objectForKey:@"sku"]]) {
            [cartItems removeObject:item];
            break;
        }
    }
    _sharedInstance = cartItems;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cartItems];
    [defaults setObject:data forKey:@"cartItems"];
    [defaults synchronize];
}

+ (void)clearCart {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _sharedInstance = [[NSArray alloc] init];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_sharedInstance];
    [defaults setObject:data forKey:@"cartItems"];
    [defaults synchronize];
}

+ (NSDictionary *)fetchProduct:(NSString *)sku {
    NSArray<NSDictionary *> *products = [Cart fetchProducts];
    for (NSMutableDictionary *item in products) {
        if([[item objectForKey:@"sku"] isEqualToString:sku]) {
            return item;
        }
    }
    return  nil;
}

+ (NSArray *)fetchProducts {
    return @[
             @{
                 @"sku": @"9780140247732",
                 @"name":@"Death of a Salesman",
                 @"price": [NSNumber numberWithFloat: 20.00],
                 @"image_url":@"https://images.randomhouse.com/cover/9780140247732",
                 @"tax":[NSNumber numberWithInt:0],
                 @"web_url": @"https://www.blueshiftreads.com/products/drama-american-general/death-of-a-salesman"
                 },
             @{
                 @"sku":@"9780140421996",
                 @"name":@"Leaves of Grass",
                 @"price":[NSNumber numberWithFloat: 13.00],
                 @"image_url":@"https://images.randomhouse.com/cover/9780140421996",
                 @"tax":[NSNumber numberWithInt:0],
                 @"web_url": @"https://www.blueshiftreads.com/products/poetry-american-general/leaves-of-grass"
                 },
             @{
                 @"sku":@"9780140455113",
                 @"name":@"The Republic (Plato)",
                 @"price":[NSNumber numberWithFloat: 12.00],
                 @"image_url":@"https://images.randomhouse.com/cover/9780140455113",
                 @"tax":[NSNumber numberWithInt:0],
                 @"web_url": @"https://www.blueshiftreads.com/products/philosophy-history-surveys-ancient-classical/the-republic-plato"
                 },
             @{
                 @"sku":@"9780142410370",
                 @"name":@"Matilda",
                 @"price":[NSNumber numberWithFloat: 6.99],
                 @"image_url":@"https://images.randomhouse.com/cover/9780142410370",
                 @"tax":[NSNumber numberWithInt:0],
                 @"web_url": @"https://www.blueshiftreads.com/products/juvenile-fiction-action-adventure-general/matilda"
                 },
             @{
                 @"sku":@"9780143038412",
                 @"name":@"Eat Pray Love",
                 @"price":[NSNumber numberWithFloat: 17.00],
                 @"image_url":@"https://images.randomhouse.com/cover/9780143038412",
                 @"tax":[NSNumber numberWithInt:0],
                 @"web_url": @"https://www.blueshiftreads.com/products/biography-autobiography-personal-memoirs/eat-pray-love"

                 },
             @{
                 @"sku":@"9780307278821",
                 @"name":@"Physics of the Impossible",
                 @"price":[NSNumber numberWithFloat: 15.95],
                 @"image_url":@"https://images.randomhouse.com/cover/9780307278821",
                 @"tax":[NSNumber numberWithInt:0],
                 @"web_url": @"https://www.blueshiftreads.com/products/science-physics-general/physics-of-the-impossible"

                 },
             @{
                 @"sku":@"9780141325293",
                 @"name":@"The Jungle Book",
                 @"price":[NSNumber numberWithFloat: 5.99],
                 @"image_url":@"https://images.randomhouse.com/cover/9780141325293",
                 @"tax":[NSNumber numberWithInt:0],
                 @"web_url": @"https://www.blueshiftreads.com/products/juvenile-fiction-classics/the-jungle-book"
                 },
             @{
                 @"sku":@"9780142424179",
                 @"name":@"The Fault in Our Stars",
                 @"price":[NSNumber numberWithFloat: 12.99],
                 @"image_url":@"https://images.randomhouse.com/cover/9780142424179",
                 @"tax":[NSNumber numberWithInt:0],
                 @"web_url": @"https://www.blueshiftreads.com/products/juvenile-fiction-social-issues-death-dying/the-fault-in-our-stars"
                 },
             @{
                 @"sku":@"9780143038580",
                 @"name":@"The Omnivore's Dilemma",
                 @"price":[NSNumber numberWithFloat: 18.00],
                 @"image_url":@"https://images.randomhouse.com/cover/9780143038580",
                 @"tax":[NSNumber numberWithInt:0],
                 @"web_url": @"https://www.blueshiftreads.com/products/health-fitness-diet-nutrition-nutrition/the-omnivore-s-dilemma"
                 },
             @{
                 @"sku":@"9780142410387",
                 @"name":@"The BFG",
                 @"price":[NSNumber numberWithFloat: 18.00],
                 @"image_url":@"https://images.randomhouse.com/cover/9780142410387",
                 @"tax":[NSNumber numberWithInt:0],
                 @"web_url": @"https://www.blueshiftreads.com/products/juvenile-fiction-action-adventure-general/the-bfg"
                 },
             @{
                 @"sku":@"9780143034759",
                 @"name":@"Alexander Hamilton",
                 @"price":[NSNumber numberWithFloat: 20.00],
                 @"image_url":@"https://images.randomhouse.com/cover/9780143034759",
                 @"tax":[NSNumber numberWithInt:0],
                 @"web_url": @"https://www.blueshiftreads.com/products/biography-autobiography-political/alexander-hamilton"
                 }
             ];
}

@end
