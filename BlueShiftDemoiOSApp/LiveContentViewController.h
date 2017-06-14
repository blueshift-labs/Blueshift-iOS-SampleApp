//
//  LiveContentViewController.h
//  BlueShiftDemoiOSApp
//
//  Created by Shahas on 19/01/17.
//  Copyright © 2017 Arjun K P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface LiveContentViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *slotTextField;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *deviceIDButton;
@property (weak, nonatomic) IBOutlet UIButton *customerIDButton;
@property (weak, nonatomic) IBOutlet UITextView *responseTextView;

- (IBAction)emailButtonDidPressed:(id)sender;
- (IBAction)deviceIDButtonDidPressed:(id)sender;
- (IBAction)customerIDButtonDidPressed:(id)sender;
- (IBAction)fetchLiveContentButtonDidPressed:(id)sender;
@end
