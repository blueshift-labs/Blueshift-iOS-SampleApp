//
//  LiveContentViewController.m
//  BlueShiftDemoiOSApp
//
//  Created by Shahas on 19/01/17.
//  Copyright © 2017 Arjun K P. All rights reserved.
//

#import "LiveContentViewController.h"
#import <BlueShift-iOS-SDK/BlueShift.h>

@interface LiveContentViewController ()

@property BOOL isEmail;
@property BOOL isCustomerID;
@property BOOL isDeviceID;

@end

@implementation LiveContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUIComponents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUIComponents {
    [self.emailButton setImage:[UIImage imageNamed:@"radioButton"] forState:UIControlStateNormal];
    [self.customerIDButton setImage:[UIImage imageNamed:@"radioButtonInactive"] forState:UIControlStateNormal];
    [self.deviceIDButton setImage:[UIImage imageNamed:@"radioButtonInactive"] forState:UIControlStateNormal];
    self.isEmail = true;
    self.isCustomerID = false;
    self.isDeviceID = false;
    //self.slotTextField.text = @"Editors_Picks_Json";
    self.slotTextField.text = @"careinappmessagingslot";
    self.responseTextView.text = @"";
    [self.responseTextView setBorderColour:[UIColor lightGrayColor] andBorderWidth:1.0];
    [self.responseTextView setCornerRadius:10.0];
}
- (IBAction)emailButtonDidPressed:(id)sender {
    [self dismissKeyboard];
    [self.emailButton setImage:[UIImage imageNamed:@"radioButton"] forState:UIControlStateNormal];
    [self.customerIDButton setImage:[UIImage imageNamed:@"radioButtonInactive"] forState:UIControlStateNormal];
    [self.deviceIDButton setImage:[UIImage imageNamed:@"radioButtonInactive"] forState:UIControlStateNormal];
    self.isEmail = true;
    self.isCustomerID = false;
    self.isDeviceID = false;
}

- (IBAction)deviceIDButtonDidPressed:(id)sender {
    [self dismissKeyboard];
    [self.emailButton setImage:[UIImage imageNamed:@"radioButtonInactive"] forState:UIControlStateNormal];
    [self.customerIDButton setImage:[UIImage imageNamed:@"radioButtonInactive"] forState:UIControlStateNormal];
    [self.deviceIDButton setImage:[UIImage imageNamed:@"radioButton"] forState:UIControlStateNormal];
    self.isEmail = false;
    self.isCustomerID = false;
    self.isDeviceID = true;

}

- (IBAction)customerIDButtonDidPressed:(id)sender {
    [self dismissKeyboard];
    [self.emailButton setImage:[UIImage imageNamed:@"radioButtonInactive"] forState:UIControlStateNormal];
    [self.customerIDButton setImage:[UIImage imageNamed:@"radioButton"] forState:UIControlStateNormal];
    [self.deviceIDButton setImage:[UIImage imageNamed:@"radioButtonInactive"] forState:UIControlStateNormal];
    self.isEmail = false;
    self.isCustomerID = true;
    self.isDeviceID = false;

}

- (void)dismissKeyboard {
    [self.slotTextField resignFirstResponder];
}

- (void)fetchLiveContentByEmail {
    NSString *slot = self.slotTextField.text;
//    [BlueShiftLiveContent fetchLiveContentByEmail:slot success:^(NSDictionary *dictionary) {
//        [self doTheStuff:dictionary];
//    } failure:^(NSError *error) {
//        self.responseTextView.text = [NSString stringWithFormat:@"%@", error];
//    }];
    NSDictionary *context = @{
                                @"seed_item_ids": @[@"9780307273482"]
                                };
//    [BlueShiftLiveContent fetchLiveContentByEmail:slot withContext:context success:^(NSDictionary *dictionary) {
//        [self doTheStuff:dictionary];
//    } failure:^(NSError *error) {
//        self.responseTextView.text = [NSString stringWithFormat:@"%@", error];
//    }];
}

- (void)fetchLiveContentByCustomerID {
    NSString *slot = self.slotTextField.text;
//    [BlueShiftLiveContent fetchLiveContentByCustomerID:slot success:^(NSDictionary *dictionary) {
//        [self doTheStuff:dictionary];
//    } failure:^(NSError *error) {
//        self.responseTextView.text = [NSString stringWithFormat:@"%@", error];
//    }];
    NSDictionary *context = @{
                              @"seed_item_ids": @[@"9780307273482"]
                              };
//    [BlueShiftLiveContent fetchLiveContentByCustomerID:slot withContext:context success:^(NSDictionary *dictionary) {
//        [self doTheStuff:dictionary];
//    } failure:^(NSError *error) {
//        self.responseTextView.text = [NSString stringWithFormat:@"%@", error];
//    }];
}

- (void)fetchLiveContentByDeviceID {
    NSString *slot = self.slotTextField.text;
//    [BlueShiftLiveContent fetchLiveContentByDeviceID:slot success:^(NSDictionary *dictionary) {
//        [self doTheStuff:dictionary];
//    } failure:^(NSError *error) {
//        self.responseTextView.text = [NSString stringWithFormat:@"%@", error];
//    }];
    NSDictionary *context = @{
                              @"seed_item_ids": @[@"9780307273482"]
                              };
//    [BlueShiftLiveContent fetchLiveContentByDeviceID:slot withContext:context success:^(NSDictionary *dictionary) {
//        [self doTheStuff:dictionary];
//    } failure:^(NSError *error) {
//        self.responseTextView.text = [NSString stringWithFormat:@"%@", error];
//    }];
}

- (void)doTheStuff:(NSDictionary *)dictionary {
    if([self isHtmlContentExist:dictionary]) {
        NSDictionary *content = [dictionary objectForKey:@"content"];
        [self showInAppNotification:[content objectForKey:@"html_content"]];
    }
    self.responseTextView.text = [NSString stringWithFormat:@"%@", dictionary];
}

- (BOOL)isHtmlContentExist:(NSDictionary *)dictionary {
    NSDictionary *content = [dictionary objectForKey:@"content"];
    if (content && [content objectForKey:@"html_content"]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)showInAppNotification:(NSString *)htmlContent {
    self.webViewPopUp = [WebViewPopUp create];
    self.webViewPopUp.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.webViewPopUp laodWebView:htmlContent];
    [self.view insertSubview:self.webViewPopUp aboveSubview:self.view];
    self.webViewPopUp.webViewPopUpDelegate = self;
}

- (void)closeButtonTapped {
    [self dismissInAppNotification];
}

- (void)dismissInAppNotification {
    [self.webViewPopUp removeFromSuperview];
}

- (IBAction)fetchLiveContentButtonDidPressed:(id)sender {
    [self dismissKeyboard];
    if(self.isEmail) {
        [self fetchLiveContentByEmail];
    } else if(self.isCustomerID) {
        [self fetchLiveContentByCustomerID];
    } else if(self.isDeviceID) {
        [self fetchLiveContentByDeviceID];
    }
}


@end
