//
//  kontaktView.h
//  RockRadioCas
//
//  Created by Jan Damek on /132/12.
//  Copyright (c) 2012 droidsoft.eu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "AudioStreamer.h"

@interface kontaktView : UIViewController <MFMessageComposeViewControllerDelegate>{
    
    NSString *orientace;
    
    UIPopoverController *popover;
    
    AudioStreamer *_streamer;
    
};

@property (nonatomic, retain) IBOutlet UIView *portreit;
@property (nonatomic, retain) IBOutlet UIView *landscape;
@property (nonatomic, retain) UIPopoverController *popover;

@property (nonatomic, retain) AudioStreamer *streamer;

- (IBAction)sendSMSButton:(id)sender;
- (IBAction)callToButton:(id)sender;
- (IBAction)backButton:(id)sender;
- (IBAction)sendEmailButton:(id)sender;
- (IBAction)infoTouch:(id)sender;

@end
