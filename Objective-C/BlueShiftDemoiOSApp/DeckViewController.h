//
//  DeckViewController.h
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 12/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import "IIViewDeckController.h"

@interface DeckViewController : IIViewDeckController

- (void)showHome;
- (void)showProduct;
- (void)showLiveContent;
- (void)showMailSubscription;
- (void)showCancelReturn;
- (void)showSubscriptionEvent;
- (void)sendPushNotification;
- (void)sendInAppNotification;
- (void)logout;

@end
