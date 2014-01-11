#import "comViewController.h"
#import "Reachability.h"
#import "kontaktView.h"

#import <SystemConfiguration/SCNetworkReachability.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MPVolumeView.h>
#import "comInfoViewController.h"

NSString *kTracksKey		= @"tracks";
NSString *kStatusKey		= @"status";
NSString *kRateKey			= @"rate";
NSString *kPlayableKey		= @"playable";
NSString *kCurrentItemKey	= @"currentItem";
NSString *kTimedMetadataKey	= @"currentItem.timedMetadata";

NSString *kUserAgent        = @"RockRadioCas iPhone player V1.0";
NSString *kRockRadioCas     = @"Rádio Čas Rock";
NSString *kURLWeb           = @"http://www.casrock.cz";
NSString *kURLFacebook      = @"http://www.facebook.com/casrock.cz";
NSString *kNastaveni        = @"Nastavení";
NSString *kWiFiNeniDostupne = @"WiFi není dostupné.";
NSString *kOK               = @"OK";
NSString *kChybaXML         = @"Chyba XML";
//NSString *kURLXML           = @"http://casrock.cz/nowplaying/rockonair.xml";
NSString *kURLXML           = @"http://casrock.cz/nowplaying/rockonair.php";
NSString *kBuffData         = @"loading data";
NSString *kURLStream        = @"http://icecast1.play.cz:8000/casrock32aac";

NSString *AudioObjectPlaybackStateDidChangeNotification = @"AudioObjectPlaybackStateDidChangeNotification";

@implementation comViewController

@synthesize player, popover, landscape, portreit;
@synthesize nazevSkladbyLabel, interpretLabel, nazevSkladbyLabelLand, interpretLabelLand;
@synthesize btnPlay, btnStop, btnShowVolume, btnHideVolume,
    btnPlayLand, btnStopLand, btnShowVolumeLand, btnHideVolumeLand;

#pragma mark -
#pragma mark Movie controller methods
#pragma mark -

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        self.view = portreit;
    }
    else
    {
        self.view = landscape;
    }
    
    [popover dismissPopoverAnimated:YES];
    
    return YES;
}

- (IBAction)wwwButton:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kURLWeb]];       
}

- (IBAction)facebookButton:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kURLFacebook]];   
}

- (IBAction)kontaktButton:(id)sender
{ 
    if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)) 
    {
        kontaktView *kontakt = [[kontaktView alloc] initWithNibName:@"kontaktView-iPad" bundle:nil];        
        kontakt.streamer = player;
        [self presentModalViewController:kontakt animated:YES];
    }
    else
    {
        kontaktView *kontakt = [[kontaktView alloc] initWithNibName:@"kontaktView-iPhone" bundle:nil];
        kontakt.streamer = player;
        [self presentModalViewController:kontakt animated:YES];
    }
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


#pragma mark Play, Stop Buttons

-(void)showStopButton
{
    btnPlay.hidden = YES;
    btnStop.hidden = NO; 
    
    btnPlayLand.hidden = YES;
    btnStopLand.hidden = NO;
}

- (IBAction)showVolume:(id)sender
{
    [myVolumeViewPort setHidden:NO];
    [myVolumeViewLand setHidden:NO];
    
    if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)) 
    {
        // toto je pro iPad, souradnice urcuji misto zobrazeni posouvatka
        [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         myVolumeViewPort.frame = CGRectMake(192, 770, 384, 22 );
                     } 
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                         btnShowVolume.hidden = YES;
                         btnHideVolume.hidden = NO;                         
                     }];     

        [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         myVolumeViewLand.frame = CGRectMake(770, 192, 22, 384 );
                     } 
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                         btnShowVolumeLand.hidden = YES;
                         btnHideVolumeLand.hidden = NO;                         
                     }];     
    }
    else
    {
        // toto je pro iPhone nasatveni kde se ma zobrazit posouvatko
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationCurveEaseOut
                         animations:^{
                             myVolumeViewPort.frame = CGRectMake(25, 360, 270, 22 );
                         } 
                         completion:^(BOOL finished){
                             NSLog(@"Done!");
                             btnShowVolume.hidden = YES;
                             btnHideVolume.hidden = NO;                         
                         }];     
        
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationCurveEaseOut
                         animations:^{
                             myVolumeViewLand.frame = CGRectMake(370, 55, 22, 215 );
                         } 
                         completion:^(BOOL finished){
                             NSLog(@"Done!");
                             btnShowVolumeLand.hidden = YES;
                             btnHideVolumeLand.hidden = NO;                         
                         }];     
        
    }
}

-(void)showPlayButton
{
    btnPlay.hidden = NO;
    btnStop.hidden = YES;
    
    btnPlayLand.hidden = NO;
    btnStopLand.hidden = YES;
      
}

- (IBAction)hideVolume:(id)sender
{ 
    if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)) 
    {
        // toto je pro iPad skryti, souradnice urcuji kam se ma posouvatko schovat   
      [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         myVolumeViewPort.frame = CGRectMake(220, 958, 5, 22 );
                     } 
                     completion:^(BOOL finished){
                         [myVolumeViewPort setHidden:YES];
                         btnShowVolume.hidden = NO;
                         btnHideVolume.hidden = YES;                         
                     }];  
    
      [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         myVolumeViewLand.frame = CGRectMake(958, 520, 5, 22 );
                     } 
                     completion:^(BOOL finished){
                         [myVolumeViewLand setHidden:YES];
                         btnShowVolumeLand.hidden = NO;
                         btnHideVolumeLand.hidden = YES;                         
                     }];     
    }
    else
    {
        // toto je pro iPhone kam se ma skryt posouvatko
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationCurveEaseOut
                         animations:^{
                             myVolumeViewPort.frame = CGRectMake(88, 440, 5, 22 );
                         } 
                         completion:^(BOOL finished){
                             [myVolumeViewPort setHidden:YES];
                             btnShowVolume.hidden = NO;
                             btnHideVolume.hidden = YES;                         
                         }];  
        
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationCurveEaseOut
                         animations:^{
                             myVolumeViewLand.frame = CGRectMake(440, 220, 5, 22 );
                         } 
                         completion:^(BOOL finished){
                             [myVolumeViewLand setHidden:YES];
                             btnShowVolumeLand.hidden = NO;
                             btnHideVolumeLand.hidden = YES;                         
                         }];     
        
    }
}

- (void)syncPlayPauseButtons
{
	if ([self isStartet])
	{
        [self showStopButton];
	}
	else
	{
        [self showPlayButton];        
	}
}

-(void)enablePlayerButtons
{
    self.btnPlay.enabled = YES;
    self.btnStop.enabled = YES;
    
    self.btnPlayLand.enabled = YES;
    self.btnStopLand.enabled = YES;
}

-(void)disablePlayerButtons
{
    self.btnPlay.enabled = NO;
    self.btnStop.enabled = NO;
    
    self.btnPlayLand.enabled = NO;
    self.btnStopLand.enabled = NO;
}

- (void)alertWiFi
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(kNastaveni, kNastaveni)
                                                        message:NSLocalizedString(kWiFiNeniDostupne,kWiFiNeniDostupne)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(kOK, kOK)
                                              otherButtonTitles:nil];
    [alertView show];        
}

#pragma mark Button Action Methods

- (void)_animationStop:(NSTimer *)timer
{
    if (btnStop.hidden == NO && btnStop.highlighted == NO)
    {       
        UIImageView *img;
        
        if (self.interfaceOrientation == UIDeviceOrientationLandscapeLeft ||
            self.interfaceOrientation == UIDeviceOrientationLandscapeRight)
        {
            img = btnStopLand.imageView;
        }
        else
            img = btnStop.imageView;
        
        if (player.state == AS_PLAYING) {
            if (img.alpha != 1)
            {
                img.alpha = 1;
            }
        } 
        else {
            if (player.state == AS_INITIALIZED || 
                player.state == AS_STARTING_FILE_THREAD ||
                player.state == AS_WAITING_FOR_DATA ||
                player.state == AS_FLUSHING_EOF ||
                player.state == AS_WAITING_FOR_QUEUE_TO_START ||
                player.state == AS_STOPPING ||
                player.state <= AS_BUFFERING) 
            {
                if (img.alpha >= 0.99 || img.alpha == 1) 
                {
                    [UIImageView beginAnimations:@"FadeOut" context: nil];
                    [UIImageView setAnimationDelegate: self];
                    [UIImageView setAnimationDuration: 0.75];
                    [UIImageView setAnimationCurve: UIViewAnimationCurveEaseIn];
                    img.alpha = img.alpha - 0.5;
                    [UIImageView commitAnimations];                     
                }
                else 
                if (img.alpha <= 0.51)
                {
                    [UIImageView beginAnimations: @"FadeIn" context: nil];
                    [UIImageView setAnimationDelegate: self];
                    [UIImageView setAnimationDuration: 0.75];
                    [UIImageView setAnimationCurve: UIViewAnimationCurveEaseOut];
                    img.alpha = img.alpha + 0.5;
                    [UIImageView commitAnimations];                     
                }
            }
        }
    }
}

- (IBAction)play:(id)sender
{  
    if ((([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == ReachableViaWiFi)) || ([defaults boolForKey:@"only_wifi"] != YES))         
    {    
         _animate = [NSTimer scheduledTimerWithTimeInterval:0.75 target:self selector:@selector(_animationStop:) userInfo:nil repeats:YES];
       
        [self initPlayer];
        
        [self doTimer];

        [self showStopButton]; 
        [player start];
    }
    else
    {
        [self showPlayButton];        
        [self alertWiFi];
    }
}

- (IBAction)pause:(id)sender
{
    [self showPlayButton];
    
	[player stop];
    
    [self doTimer];
    
    if (_animate != nil)
    {   
        [_animate invalidate];
        _animate = nil;
    }
    
}

#pragma mark -
#pragma mark View Controller
#pragma mark -

- (void)viewDidUnload
{  
    self.btnPlay = nil;
    self.btnStop = nil;
    self.nazevSkladbyLabel = nil;
    self.interpretLabel = nil;
    
    [_redrawTimer invalidate];
    _redrawTimer = nil;
    
    [super viewDidUnload];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser{
    NSLog(@"File found and parsing started");
    
}

- (void)doTimer{
    // on timer 
    [self syncPlayPauseButtons];    

    if (btnPlay.hidden == NO)
    {        
        [nazevSkladbyLabel setText:kRockRadioCas];
        [interpretLabel setText:@""];

        [nazevSkladbyLabelLand setText:kRockRadioCas];
        [interpretLabelLand setText:@""];
               
    }
    else
    {
        if (player.state == AS_PLAYING)
        {
            [self parseXMLFileAtURL:kURLXML];
        
            [nazevSkladbyLabel setText:_nazevSkladby];        
            [interpretLabel setText:_interpret];

            [nazevSkladbyLabelLand setText:_nazevSkladby];        
            [interpretLabelLand setText:_interpret];
        
            NSString *dohromady = _nazevSkladby;
            if (_interpret != @"")
            {
                dohromady = [[dohromady stringByAppendingString:@" - "] stringByAppendingString:_interpret];
            }
        }
    }
       
}

- (void)_frameTimerFired:(NSTimer *)timer {
    [self doTimer];    
}

- (void) handlePlaybackStateChanged: (id) notification {
    
    _interupted = [player isPlaying];
    
    if (player.stopOnCall)
        [player start];
}

- (void)viewDidLoad
{     
    [super viewDidLoad];
    
    _interupted = NO;
    
    NSString *iIosVersion = [[UIDevice currentDevice] systemVersion];
    
    if ( [iIosVersion compare:@"4.9.9"]==NSOrderedAscending)
    {
        UIFont *font;
      if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
      {
        font = [UIFont fontWithName:@"Marker Felt" size:17];
      }else {
          font = [UIFont fontWithName:@"Marker Felt" size:30];          
      }
        [nazevSkladbyLabel setFont:font];
        [nazevSkladbyLabelLand setFont:font];
        [interpretLabelLand setFont:font];
        [interpretLabel setFont:font];
    }

    NSDictionary *userDefaultsDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                          kURLStream, @"stream",
                                          nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:userDefaultsDefaults];    
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    
    myVolumeViewPort =
    [[MPVolumeView alloc] initWithFrame: CGRectMake(88, 440, 5, 22 )];
    [myVolumeViewPort setShowsRouteButton:YES]; 
    myVolumeViewPort.showsVolumeSlider=YES;
    [self.portreit addSubview: myVolumeViewPort];
    myVolumeViewPort.hidden = YES;

    myVolumeViewLand =
    [[MPVolumeView alloc] initWithFrame: CGRectMake(468, 85, 5, 22 )];    
    [myVolumeViewLand setShowsRouteButton:YES]; 
    [self.landscape addSubview: myVolumeViewLand];
    myVolumeViewLand.transform = CGAffineTransformRotate(myVolumeViewLand.transform, 270.0/180*M_PI);
    myVolumeViewLand.hidden = YES;
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver: self
                           selector: @selector (handlePlaybackStateChanged:)
                               name: AudioObjectPlaybackStateDidChangeNotification
                             object: nil];    
    
    _redrawTimer = [NSTimer scheduledTimerWithTimeInterval:10
                                                     target:self
                                                   selector:@selector(_frameTimerFired:)
                                                   userInfo:nil
                                                    repeats:YES];     
    
    // automaticke spusteni streamu podle nastaveni
    if (([defaults boolForKey:@"auto_play"] == YES)&& 
        ((([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == ReachableViaWiFi)) || ([defaults boolForKey:@"only_wifi"] != YES))) 
    {
        [self initPlayer];
    }
    
    [self doTimer];
    
}

- (BOOL) isStartet
{
    return player.state == AS_STARTING_FILE_THREAD ||
        player.state == AS_WAITING_FOR_DATA ||
	player.state == AS_FLUSHING_EOF ||
	player.state == AS_WAITING_FOR_QUEUE_TO_START ||
	player.state == AS_PLAYING ||
	player.state == AS_BUFFERING;

}

- (void)initPlayer
{
    if (![self isStartet]) {
    if ((([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == ReachableViaWiFi)) || ([defaults boolForKey:@"only_wifi"] != YES))         
    {       
        NSString *u=[defaults objectForKey:@"stream"];      
        NSURL *url = [NSURL URLWithString:u];
        player = [[AudioStreamer alloc] initWithURL:url];
    }
    else
    {
        [self pause:0];
        [self showPlayButton];
        [self alertWiFi];
    }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:nil];
    [self.player removeObserver:self forKeyPath:kCurrentItemKey];
    [self.player removeObserver:self forKeyPath:kTimedMetadataKey];
    [self.player removeObserver:self forKeyPath:kRateKey];
    
    [super dealloc];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    
    NSString *errorString = [NSString stringWithFormat:@"Error code %i", [parseError code]];
    NSLog(@"Error parsing XML: %@", errorString);
    
    [interpretLabel setText:@""];
    [nazevSkladbyLabel setText:NSLocalizedString(kChybaXML, kChybaXML)];
    
    [interpretLabelLand setText:@""];
    [nazevSkladbyLabelLand setText:NSLocalizedString(kChybaXML, kChybaXML)];
    
    errorParsing=YES;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    currentElement = [elementName copy];
    ElementValue = [[NSMutableString alloc] init];                
    
    if ([elementName isEqualToString:@"item"]) {
        item = [[NSMutableDictionary alloc] init];
        
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    [ElementValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if ([elementName isEqualToString:@"TITLE"])
    {
        _nazevSkladby = [ElementValue copy];
    }
    else if ([elementName isEqualToString:@"ARTIST"])
    {
        _interpret = [ElementValue copy];
    }     
}

- (void)parseXMLFileAtURL:(NSString *)URL
{    
    articles = [[NSMutableArray alloc] init];
    errorParsing=NO;
    
    rssParser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:URL]];
    [rssParser setDelegate:self];
    
    // You may need to turn some of these on depending on the type of XML file you are parsing
    [rssParser setShouldProcessNamespaces:NO];
    [rssParser setShouldReportNamespacePrefixes:NO];
    [rssParser setShouldResolveExternalEntities:NO];
    
    [rssParser parse];    
    
}

@end
