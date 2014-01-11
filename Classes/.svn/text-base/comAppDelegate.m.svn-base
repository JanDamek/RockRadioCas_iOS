//
//  comAppDelegate.m
//  RockRadioCas
//
//  Created by Jan Damek on /52/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "comAppDelegate.h"
#import <MessageUI/MFMessageComposeViewController.h>

@implementation comAppDelegate

@synthesize window;
@synthesize mainComViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    
//    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
//    [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"version_preference"];
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = @"Obsah SMS pro odeslani";    
        controller.recipients = [NSArray arrayWithObjects:@"775908302",nil];
        controller.messageComposeDelegate = self;        
    }
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setDelegate:self];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
    
    /* Pick any one of them */
    // 1. Overriding the output audio route
    //UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    //AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
    
    // 2. Changing the default output audio route
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
    {    
        UInt32 doChangeDefaultRoute = 1;
        AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);
    }
   
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setDelegate:self];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
    
    /* Pick any one of them */
    // 1. Overriding the output audio route
    //UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    //AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
    
    // 2. Changing the default output audio route
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
    {    
        UInt32 doChangeDefaultRoute = 1;
        AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);
    }

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result;
{
    
}

- (void)beginInterruption
{
    NSLog (@"Audio session was interrupted.");
    
//    if ([player isPlaying])
    {
//        [player stop];
        _interupted = YES;
        
        NSString *AudioObjectPlaybackStateDidChangeNotification = @"AudioObjectPlaybackStateDidChangeNotification";
        [[NSNotificationCenter defaultCenter] postNotificationName: AudioObjectPlaybackStateDidChangeNotification object: self]; 
        
    }
}

- (void) endInterruptionWithFlags: (NSUInteger) flags {
    
    // Test if the interruption that has just ended was one from which this app 
    //    should resume playback.
    if (flags & AVAudioSessionInterruptionFlags_ShouldResume) {
        
        NSError *endInterruptionError = nil;
        [[AVAudioSession sharedInstance] setActive: YES
                                             error: &endInterruptionError];
        if (endInterruptionError != nil) {
            
            NSLog (@"Unable to reactivate the audio session after the interruption ended.");
            return;
            
        } else {
            
            NSLog (@"Audio session reactivated after interruption.");
            
            if (_interupted) {
                
                _interupted = NO;
                
                // Resume playback by sending a notification to the controller object, which
                //    in turn invokes the playOrStop: toggle method.
                NSString *AudioObjectPlaybackStateDidChangeNotification = @"AudioObjectPlaybackStateDidChangeNotification";
                [[NSNotificationCenter defaultCenter] postNotificationName: AudioObjectPlaybackStateDidChangeNotification object: self]; 
                
            }
        }
    }
}


@end