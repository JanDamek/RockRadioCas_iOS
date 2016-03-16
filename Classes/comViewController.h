//
//  comViewController.h
//  RockRadioCas
//
//  Created by Jan Damek on /52/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "Reachability.h"
#import "comPlayer.h"

@interface comViewController : UIViewController <comPlayerDelegate, NSXMLParserDelegate, ADBannerViewDelegate> {
    
    NSURLConnection *xmlFile;
    NSXMLParser *rssParser;
    NSMutableArray *articles;
    NSMutableDictionary *item;
    NSString *currentElement;
    NSMutableString *ElementValue;
    BOOL errorParsing;  
    
    NSString *_nazevSkladby;
    NSString *_interpret;
    NSUserDefaults *defaults; 
    }

@property (nonatomic, retain) IBOutlet UIButton *btnPlay;
@property (nonatomic, retain) IBOutlet UIButton *btnStop;
@property (nonatomic, retain) IBOutlet UILabel  *interpretLabel;
@property (nonatomic, retain) IBOutlet UILabel  *nazevSkladbyLabel;

@property (strong, nonatomic) comPlayer *player;

- (IBAction)play:(id)sender;
- (IBAction)pause:(id)sender;

@end
