//
//  DeckViewController.m
//  BaseiOSApp-ObjC
//
//  Created by Arjun K P on 12/02/15.
//  Copyright (c) 2015 Arjun K P. All rights reserved.
//

#import "DeckViewController.h"

@interface DeckViewController ()

@end

@implementation DeckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.leftController = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:@"SideMenuViewController"];
    self.centerController = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:@"MainNavigationController"];
    
    self.leftSize = 60.0; // Size in (virtual) pixels, that is hidden of the side menu (and NOT the width of the menu)
    //[self setPanningMode:IIViewDeckNoPanning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showHome {
    UINavigationController *centerController = (UINavigationController*)self.centerController;
    [centerController popToRootViewControllerAnimated:YES];
}

@end
