//
//  comAppDelegate.m
//  RockRadioCas
//
//  Created by Jan Damek on /52/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "comAppDelegate.h"

@implementation comAppDelegate

@synthesize player = _player;

NSString *kURLStream        = @"http://icecast1.play.cz:8000/casrock32aac";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [comPlayer prepareBackgroundPlayAndSetDefaultSoundRoute];
    _player = [[comPlayer alloc]initWithURL:kURLStream];
   
    return YES;
}

@end