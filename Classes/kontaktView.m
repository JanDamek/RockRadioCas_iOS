//
//  kontaktView.m
//  RockRadioCas
//
//  Created by Jan Damek on /132/12.
//  Copyright (c) 2012 droidsoft.eu. All rights reserved.
//

#import "kontaktView.h"

#import "comInfoViewController.h"
#import "comAppDelegate.h"

@implementation kontaktView

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.canDisplayBannerAds = true;
}

- (IBAction)sendSMSButton:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = @"";    
        controller.recipients = [NSArray arrayWithObjects:@"+420725331155",nil];
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }  
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.view setNeedsDisplay];
}

- (IBAction)sendEmailButton:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:studio@casrock.cz"]];   
}

- (IBAction)callToButton:(id)sender
{
    comAppDelegate *d = (comAppDelegate*)[[UIApplication sharedApplication]delegate];
    [d.player stop];
    
    UIWebView *callWebview = [[UIWebView alloc] init];
    NSURL *telURL = [NSURL URLWithString:@"tel:+420725331155"];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
}

- (IBAction)backButton:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
