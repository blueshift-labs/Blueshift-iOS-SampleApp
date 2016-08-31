//
//  SubscriptionEventsViewController.m
//  BlueShiftDemoiOSApp
//
//  Created by Arjun K P on 12/03/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import "SubscriptionEventsViewController.h"

@implementation SubscriptionEventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Subscription Events";
    [self.navigationController setNavigationBarHidden:NO];
    
    self.subscriptionTypes = @[@"subscription001", @"subscription002"];
    self.subscriptionTypePickerView.delegate = self;
    
    [self setDefaultSubscription];
    
    [self.subscriptionTypePickerView reloadAllComponents];
    
}

- (void)setDefaultSubscription {
    self.currentSubscription = (NSString *)[self.subscriptionTypes firstObject];
    self.cycleLength = 10;
    self.cycleType = @"cycleType1";
    self.price = 10.9098;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.subscriptionTypes.count;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    self.currentSubscription = [self.subscriptionTypes objectAtIndex:row];
    
    if ([self.currentSubscription isEqualToString:@"subscription001"]) {
        self.cycleLength = 10;
        self.cycleType = @"cycleType1";
        self.price = 10.9098;
    } else {
        self.cycleLength = 20;
        self.cycleType = @"cycleType2";
        self.price = 18.9096;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component{
    return [self.subscriptionTypes objectAtIndex:row];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[BlueShift sharedInstance] trackScreenViewedForViewController:self canBatchThisEvent:YES];
}

- (IBAction)initializeButtonPressed:(id)sender {
    NSTimeInterval currentTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate];
    [[BlueShift sharedInstance] trackSubscriptionInitializationForSubscriptionState:BlueShiftSubscriptionStateStart andCycleType:self.cycleType andCycleLength:self.cycleLength andSubscriptionType:self.currentSubscription andPrice:self.price andStartDate:currentTimeInterval canBatchThisEvent:NO];
    
}

- (IBAction)pauseButtonPressed:(id)sender {
    [[BlueShift sharedInstance] trackSubscriptionPauseWithBatchThisEvent:NO];
}

- (IBAction)unPauseButtonPressed:(id)sender {
    [[BlueShift sharedInstance] trackSubscriptionUnpauseWithBatchThisEvent:NO];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [[BlueShift sharedInstance] trackSubscriptionCancelWithBatchThisEvent:NO];
}

@end
