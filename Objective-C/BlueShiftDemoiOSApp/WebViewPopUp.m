//
//  WebViewPopUp.m
//  BlueShiftDemoiOSApp
//
//  Created by shahas kp on 01/02/18.
//  Copyright © 2018 Arjun K P. All rights reserved.
//

#import "WebViewPopUp.h"
#import "UIView+BfViewHelpers.h"

@implementation WebViewPopUp

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


+ (WebViewPopUp *)create
{
    WebViewPopUp *webViewPopUp = [[[NSBundle mainBundle] loadNibNamed:@"WebViewPopUp" owner:self options:nil] objectAtIndex:0];
    [webViewPopUp.closeButton setBorderColour:[UIColor whiteColor] andBorderWidth:1.0];
    [webViewPopUp.closeButton setCornerRadius:10];
    return webViewPopUp;
}

+ (WebViewPopUp *)createFullView
{
    WebViewPopUp *webViewPopUp = [[[NSBundle mainBundle] loadNibNamed:@"WebViewPopUpFull" owner:self options:nil] objectAtIndex:0];
    [webViewPopUp.closeButton setBorderColour:[UIColor whiteColor] andBorderWidth:1.0];
    [webViewPopUp.closeButton setCornerRadius:10];
    return webViewPopUp;
}

+ (WebViewPopUp *)createTopView
{
    WebViewPopUp *webViewPopUp = [[[NSBundle mainBundle] loadNibNamed:@"WebViewPopUpTop" owner:self options:nil] objectAtIndex:0];
    [webViewPopUp.closeButton setBorderColour:[UIColor whiteColor] andBorderWidth:1.0];
    [webViewPopUp.closeButton setCornerRadius:10];
    return webViewPopUp;
}

+ (WebViewPopUp *)createCenterView
{
    WebViewPopUp *webViewPopUp = [[[NSBundle mainBundle] loadNibNamed:@"WebViewPopUpCenter" owner:self options:nil] objectAtIndex:0];
    [webViewPopUp.closeButton setBorderColour:[UIColor whiteColor] andBorderWidth:1.0];
    [webViewPopUp.closeButton setCornerRadius:10];
    return webViewPopUp;
}

+ (WebViewPopUp *)createBottomView
{
    WebViewPopUp *webViewPopUp = [[[NSBundle mainBundle] loadNibNamed:@"WebViewPopUpBottom" owner:self options:nil] objectAtIndex:0];
    [webViewPopUp.closeButton setBorderColour:[UIColor whiteColor] andBorderWidth:1.0];
    [webViewPopUp.closeButton setCornerRadius:10];
    return webViewPopUp;
}



- (void)laodWebView:(NSString *)htmlString {
    [self.webView loadHTMLString:htmlString baseURL:NULL];
}

- (IBAction)closeButtonDidTapped:(id)sender {
    [self.webViewPopUpDelegate closeButtonTapped];
}


@end
