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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)wwwTouch:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.digitalscope.cz/"]];      
}

- (IBAction)facebookTouch:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/pages/DigitalScopecz/359469067407335"]];          
}

- (IBAction)emailTouch:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:support@digitalscope.cz"]];          
}

- (IBAction)backTouch:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
