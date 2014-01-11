//
//  kontaktView.m
//  RockRadioCas
//
//  Created by Jan Damek on /132/12.
//  Copyright (c) 2012 droidsoft.eu. All rights reserved.
//

#import "kontaktView.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import "comInfoViewController.h"

NSString *port		= @"port";
NSString *land		= @"land";

@implementation kontaktView

@synthesize portreit, landscape, popover, streamer;

- (IBAction)sendSMSButton:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = @"";    
        controller.recipients = [NSArray arrayWithObjects:@"725331155",nil];
        controller.messageComposeDelegate = self;
        [self presentModalViewController:controller animated:YES];
    }  
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissModalViewControllerAnimated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.view setNeedsDisplay];
}

- (IBAction)infoTouch:(id)sender
{
    if ([popover isPopoverVisible]) {
        [popover dismissPopoverAnimated:YES];
    }else {
        if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)) 
        {
            comInfoViewController *info = [[comInfoViewController alloc] initWithNibName:@"infoView-iPad" bundle:nil];
            popover = [[UIPopoverController alloc] initWithContentViewController:info];
            [info release];
            
            [popover setPopoverContentSize:info.view.frame.size];
            
            [popover presentPopoverFromRect:[(UIButton *)sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
        }else {
            comInfoViewController *info = [[[comInfoViewController alloc] initWithNibName:@"infoView-iPhone" bundle:nil] autorelease];
            [self presentModalViewController:info animated:YES];
        }
    }
}

- (IBAction)sendEmailButton:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:studio@casrock.cz"]];   
}

- (IBAction)callToButton:(id)sender
{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:725331155"]];    
    
    streamer.stopOnCall = [streamer isPlaying];
    [streamer stop];

    UIWebView *callWebview = [[UIWebView alloc] init];
    NSURL *telURL = [NSURL URLWithString:@"tel:725331155"];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
}

- (IBAction)backButton:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        self.view = portreit;
        orientace = port;
    }
    else
    {
        self.view = landscape;
        orientace = land;
    }
    
    [popover dismissPopoverAnimated:YES];
    
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (orientace==land)
    {
        self.view = landscape;
    }
    else
    {
        self.view = portreit;
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
