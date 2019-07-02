//
//  WebViewPopUp.h
//  BlueShiftDemoiOSApp
//
//  Created by shahas kp on 01/02/18.
//  Copyright © 2018 Arjun K P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@protocol WebViewPopUpDelegate <NSObject>

@optional
- (void) closeButtonTapped;
@end

@interface WebViewPopUp : UIView

@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (nonatomic,retain) id<WebViewPopUpDelegate> webViewPopUpDelegate;

- (IBAction)closeButtonDidTapped:(id)sender;

+ (WebViewPopUp *)create;
+ (WebViewPopUp *)createFullView;
+ (WebViewPopUp *)createTopView;
+ (WebViewPopUp *)createCenterView;
+ (WebViewPopUp *)createBottomView;
- (void)laodWebView:(NSString *)htmlString;

@end
