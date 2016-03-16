//
//  comInfoViewController.m
//  RockRadioCas
//
//  Created by Jan Damek on /103/12.
//  Copyright (c) 2012 droidsoft.eu. All rights reserved.
//

#import "comInfoViewController.h"

@interface comInfoViewController ()

@end

@implementation comInfoViewController

- (IBAction)backButton:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.canDisplayBannerAds = true;
}

@end
