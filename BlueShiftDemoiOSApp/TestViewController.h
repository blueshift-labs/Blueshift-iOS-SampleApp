//
//  TestViewController.h
//  BlueShiftDemoiOSApp
//
//  Created by Arjun K P on 13/03/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>

@interface TestViewController : UIViewController

@property IBOutlet UIView *cameraView;
@property(nonatomic, retain) IBOutlet UIImageView *capturedImageView;

@property(nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;


- (IBAction)captureButtonPressed:(id)sender;


@end
