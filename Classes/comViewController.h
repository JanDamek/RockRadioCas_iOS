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
#import "AudioStreamer.h"
#import "Reachability.h"

@class AVPlayer;
@class AVPlayerItem;

@interface comViewController : UIViewController <AVAudioPlayerDelegate, NSXMLParserDelegate, AVAudioSessionDelegate> {
    
    AudioStreamer *player;

    //portrait prvky
    UIButton *btnPlay;
    UIButton *btnStop;
    UIButton *btnShowVolume;
    UIButton *btnHideVolume;
    
    UILabel *nazevSkladbyLabel;
    UILabel *interpretLabel;
    
    //landscape prvky
    UIButton *btnPlayLand;
    UIButton *btnStopLand;
    UIButton *btnShowVolumeLand;
    UIButton *btnHideVolumeLand;
    
    UILabel *nazevSkladbyLabelLand;
    UILabel *interpretLabelLand;

    
    NSTimer *_redrawTimer;
    NSTimer *_animate;
     
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
    
    UIPopoverController *popover;
    
    BOOL _interupted;          
}

@property (nonatomic, retain) IBOutlet UIButton *btnPlay;
@property (nonatomic, retain) IBOutlet UIButton *btnStop;
@property (nonatomic, retain) IBOutlet UIButton *btnShowVolume;
@property (nonatomic, retain) IBOutlet UIButton *btnHideVolume;
@property (nonatomic, retain) IBOutlet UIButton *btnPlayLand;
@property (nonatomic, retain) IBOutlet UIButton *btnStopLand;
@property (nonatomic, retain) IBOutlet UIButton *btnShowVolumeLand;
@property (nonatomic, retain) IBOutlet UIButton *btnHideVolumeLand;
@property (nonatomic, retain) IBOutlet UILabel *nazevSkladbyLabel;
@property (nonatomic, retain) IBOutlet UILabel *interpretLabel;
@property (nonatomic, retain) IBOutlet UILabel *nazevSkladbyLabelLand;
@property (nonatomic, retain) IBOutlet UILabel *interpretLabelLand;

@property (nonatomic, retain) IBOutlet UIView *portreit;
@property (nonatomic, retain) IBOutlet UIView *landscape;

@property (nonatomic, retain) AudioStreamer *player;
@property (nonatomic, retain) UIPopoverController *popover;

- (IBAction)play:(id)sender;
- (IBAction)pause:(id)sender;
- (IBAction)showVolume:(id)sender;
- (IBAction)hideVolume:(id)sender;
- (IBAction)wwwButton:(id)sender;
- (IBAction)facebookButton:(id)sender;
- (IBAction)kontaktButton:(id)sender;
- (IBAction)infoTouch:(id)sender;

- (void)parseXMLFileAtURL:(NSString *)URL;
- (void)initPlayer;
- (void)doTimer;

@end
