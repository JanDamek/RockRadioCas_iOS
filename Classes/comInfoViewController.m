//
//  comInfoViewController.m
//  RockRadioCas
//
//  Created by Jan Damek on /103/12.
//  Copyright (c) 2012 droidsoft.eu. All rights reserved.
//

@import GoogleMobileAds;

#import "comInfoViewController.h"
#import "ServiceTools.h"

@interface comInfoViewController ()

@property (retain, nonatomic) IBOutlet GADBannerView *bannerView;

@end

@implementation comInfoViewController

- (IBAction)backButton:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [ServiceTools GADInitialization:_bannerView rootViewController:self];
}

- (void)dealloc {
    [_bannerView release];
    [super dealloc];
}
@end
