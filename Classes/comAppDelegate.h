//
//  comAppDelegate.h
//  RockRadioCas
//
//  Created by Jan Damek on /52/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "comPlayer.h"

@interface comAppDelegate : UIResponder <UIApplicationDelegate, comPlayerDelegate>

@property (strong, nonatomic) comPlayer *player;
@property (strong, nonatomic) UIWindow *window;

@end
