//
//  comViewController.h
//  RockRadioCas
//
//  Created by Jan Damek on /52/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MPVolumeView.h>
#import "kontaktView.h"

@class AVPlayer;
@class AVPlayerItem;

@interface comViewController : UIViewController <AVAudioPlayerDelegate> {
    
    
    AVPlayer *player;
    AVPlayerItem *playerItem;

    //portrait prvky
    UIButton *playButton;
    UIButton *stopButton;
    UIButton *showVolumeButton;
    UIButton *hideVolumeButton;
    UILabel *nazevSkladbyLabel;
    UILabel *interpretLabel;
    
    //landscape prvky
    UIButton *playButtonLand;
    UIButton *stopButtonLand;
    UIButton *showVolumeButtonLand;
    UIButton *hideVolumeButtonLand;
    UILabel *nazevSkladbyLabelLand;
    UILabel *interpretLabelLand;
    
    NSTimer *_redrawTimer;
     
	NSArray *adList;
    
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
    
    UIView *landscape;
    UIView *portreit;
  
    MPVolumeView *myVolumeViewPort;
    MPVolumeView *myVolumeViewLand;
          
}

@property (nonatomic, retain) IBOutlet UIButton *playButton;
@property (nonatomic, retain) IBOutlet UIButton *stopButton;
@property (nonatomic, retain) IBOutlet UIButton *showVolumeButton;
@property (nonatomic, retain) IBOutlet UIButton *hideVolumeButton;
@property (nonatomic, retain) IBOutlet UILabel *nazevSkladbyLabel;
@property (nonatomic, retain) IBOutlet UILabel *interpretLabel;
@property (nonatomic, retain) IBOutlet UIButton *playButtonLand;
@property (nonatomic, retain) IBOutlet UIButton *stopButtonLand;
@property (nonatomic, retain) IBOutlet UIButton *showVolumeButtonLand;
@property (nonatomic, retain) IBOutlet UIButton *hideVolumeButtonLand;
@property (nonatomic, retain) IBOutlet UILabel *nazevSkladbyLabelLand;
@property (nonatomic, retain) IBOutlet UILabel *interpretLabelLand;

@property (nonatomic, retain) IBOutlet UIView *portreit;
@property (nonatomic, retain) IBOutlet UIView *landscape;


@property (retain) AVPlayer *player;
@property (retain) AVPlayerItem *playerItem;

- (IBAction)play:(id)sender;
- (IBAction)pause:(id)sender;
- (IBAction)showVolume:(id)sender;
- (IBAction)hideVolume:(id)sender;
- (IBAction)wwwButton:(id)sender;
- (IBAction)facebookButton:(id)sender;
- (IBAction)kontaktButton:(id)sender;


- (void)parseXMLFileAtURL:(NSString *)URL;
- (void)initPlayer;
- (void)doTimer;

@end
