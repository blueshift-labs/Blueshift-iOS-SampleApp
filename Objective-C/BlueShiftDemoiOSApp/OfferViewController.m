//
//  OfferViewController.m
//  BlueShiftDemoiOSApp
//
//  Created by Arjun K P on 12/03/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import "OfferViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation OfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Offer Page";
    [self.navigationController setNavigationBarHidden:NO];
    [[BlueShift sharedInstance] setPushParamDelegate:self];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.offerImageView sd_setImageWithURL:[NSURL URLWithString:self.imageURL] placeholderImage:nil];
    [[BlueShift sharedInstance] trackScreenViewedForViewController:self canBatchThisEvent:YES];
}


- (void)handlePushDictionary:(NSDictionary *)details {
    
    self.imageURL = [details objectForKey:@"image_url"];
    
}

@end
