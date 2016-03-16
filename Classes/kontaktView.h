//
//  kontaktView.h
//  RockRadioCas
//
//  Created by Jan Damek on /132/12.
//  Copyright (c) 2012 droidsoft.eu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface kontaktView : UIViewController <ADBannerViewDelegate,MFMessageComposeViewControllerDelegate>

- (IBAction)sendSMSButton:(id)sender;
- (IBAction)callToButton:(id)sender;
- (IBAction)sendEmailButton:(id)sender;

@end
