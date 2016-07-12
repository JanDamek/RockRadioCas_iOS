
@import GoogleMobileAds;

#import "comViewController.h"
#import "Reachability.h"
#import "comAppDelegate.h"
#import "ServiceTools.h"

@interface comViewController ()

@property (retain, nonatomic) IBOutlet GADBannerView *bannerView;

@end

NSString *kUserAgent        = @"RockRadioCas iPhone player V1.0";
NSString *kRockRadioCas     = @"Rádio Čas Rock";
NSString *kURLWeb           = @"http://www.casrock.cz";
NSString *kURLFacebook      = @"http://www.facebook.com/casrock.cz";
NSString *kNastaveni        = @"Nastavení";
NSString *kWiFiNeniDostupne = @"WiFi není dostupné.";
NSString *kOK               = @"OK";
NSString *kChybaXML         = @"Chyba XML";
NSString *kURLStreamDefault = @"http://icecast1.play.cz:8000/casrock32aac";
NSString *kURLXML           = @"http://casrock.cz/nowplaying/rockonair.php";
NSString *kBuffData         = @"Loading data";

@implementation comViewController{
    BOOL isStarted;
}

@synthesize nazevSkladbyLabel, interpretLabel, player=_player;
@synthesize btnPlay, btnStop;

#pragma mark Play, Stop Buttons

-(comPlayer *)player{
    if (_player==nil){
        comAppDelegate *d = (comAppDelegate*)[[UIApplication sharedApplication]delegate];
        _player = d.player;
        [_player setDelegate:self];
    }
    return _player;
}

-(void)showStopButton
{
    btnPlay.hidden = YES;
    btnStop.hidden = NO;
}

-(void)showPlayButton
{
    btnPlay.hidden = NO;
    btnStop.hidden = YES;
    
}

- (void)syncPlayPauseButtons
{
    if (isStarted)
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
}

-(void)disablePlayerButtons
{
    self.btnPlay.enabled = NO;
    self.btnStop.enabled = NO;
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

- (IBAction)play:(id)sender
{
    if ((([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == ReachableViaWiFi)) || ([defaults boolForKey:@"only_wifi"] != YES))
    {
        [self initPlayer];
        
        [self showStopButton];
        [self.player play];
        isStarted = YES;
    }
    else
    {
        [self showPlayButton];
        [self alertWiFi];
        
        isStarted = NO;
    }
    [self parseXMLFileAtURL:kURLXML];
}

- (IBAction)pause:(id)sender
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    [self showPlayButton];
    
    [self.player stop];
    isStarted = NO;

    nazevSkladbyLabel.text = @"";
    interpretLabel.text = @"";
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
    
    [super viewDidUnload];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser{
    NSLog(@"File found and parsing started");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isStarted = NO;
    
    nazevSkladbyLabel.text = @"";
    interpretLabel.text = @"";
    
    NSDictionary *userDefaultsDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                          kURLStreamDefault, @"stream",
                                          nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:userDefaultsDefaults];
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    // automaticke spusteni streamu podle nastaveni
    if (([defaults boolForKey:@"auto_play"] == YES)&&
        ((([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == ReachableViaWiFi)) || ([defaults boolForKey:@"only_wifi"] != YES)))
    {
        [self initPlayer];
    }
    
    [ServiceTools GADInitialization:_bannerView rootViewController:self];
}

- (void)initPlayer
{
    if (!isStarted) {
        if ((([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == ReachableViaWiFi)) || ([defaults boolForKey:@"only_wifi"] != YES))
        {
            NSString *u=[defaults objectForKey:@"stream"];
            [self.player setStreamURL:u];
            [self.player play];
            isStarted = YES;
        }
        else
        {
            [self pause:0];
            [self showPlayButton];
            [self alertWiFi];
            isStarted = NO;
        }
    }
}
-(void)metaData:(comPlayer *)player meta:(NSString *)meta{
    [self parseXMLFileAtURL:kURLXML];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    
    NSString *errorString = [NSString stringWithFormat:@"Error code %li", (long)[parseError code]];
    NSLog(@"Error parsing XML: %@", errorString);
    
    [interpretLabel setText:@""];
    [nazevSkladbyLabel setText:NSLocalizedString(kChybaXML, kChybaXML)];
    
    errorParsing=YES;
    
    [self performSelector:@selector(parseXMLFileAtURL:) withObject:kURLXML afterDelay:60.0];
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

-(void)parserDidEndDocument:(NSXMLParser *)parser{
    [self performSelector:@selector(parseXMLFileAtURL:) withObject:kURLXML afterDelay:60.0];
    nazevSkladbyLabel.text = _nazevSkladby;
    interpretLabel.text = _interpret;
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
    if (isStarted){
        articles = [[NSMutableArray alloc] init];
        errorParsing=NO;
        
        rssParser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:URL]];
        [rssParser setDelegate:self];
        
        // You may need to turn some of these on depending on the type of XML file you are parsing
        [rssParser setShouldProcessNamespaces:NO];
        [rssParser setShouldReportNamespacePrefixes:NO];
        [rssParser setShouldResolveExternalEntities:NO];
        
        [rssParser parse];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

- (void)dealloc {
    [_bannerView release];
    [super dealloc];
}
@end
