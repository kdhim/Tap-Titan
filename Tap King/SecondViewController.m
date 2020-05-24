//
//  SecondViewController.m
//  Tap King
//
//  Created by kevin dhimitri on 7/13/14.
//  Copyright (c) 2014 kevin dhimitri. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)updateTime:(NSTimer*)timer
{
    secs--;
    NSString* updatedTime = [NSString stringWithFormat:@"%d", secs];
    timerText.text = updatedTime;
    
    if (inDiamond)
    {
        secs_diamond--;
        if (secs_diamond == 0)
        {
            [self exitDiamondWorld];
        }
    }

    if (rand()%9 == 0 && ([UnusedBalloonImgTags count] > 0)) // 1/10 chance
    {
        NSUInteger randomIndex = arc4random() % [UnusedBalloonImgTags count];
        NSNumber* objx = (NSNumber*)[UnusedBalloonImgTags objectAtIndex:randomIndex];
        int thetag = [objx intValue];
        CGFloat destX = 0.0, destY = 0.0;
        
        object_count++;
        balloon_count++;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            if (thetag == 100) // bot left
            {
                destX = 500; destY = 100;
            }
            
            if (thetag == 101) // bot right
            {
                destX = -100; destY = 100;
            }
            
            if (thetag == 102) // up left
            {
                destX = 500; destY = 500;
            }
            
            if (thetag == 103) // up right
            {
                destX = -100; destY = 500;
            }
        }
        else
        {
            if (thetag == 100) // bot left
            {
                destX = 900; destY = 150;
            }
            
            if (thetag == 101) // bot right
            {
                destX = -150; destY = 100;
            }
            
            if (thetag == 102) // up left
            {
                destX = 900; destY = 1050;
            }
            
            if (thetag == 103) // up right
            {
                destX = -150; destY = 1130;
            }

        }
        
        [self MoveObject:thetag button_add:4 xpos:destX ypos:destY dur:4.0];
        [UnusedBalloonImgTags removeObject:objx];
    }
    if (rand()%13 == 0) // ~(1/14) chance. if no balloon, maybe a crown?
    {
        int rand_x, rand_y;
        object_count++;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            NSMutableArray* mycoords = [self getGoodCoords:false width:80 height:84];
            rand_x = [mycoords[0] intValue];
            rand_y = [mycoords[1] intValue];
            crownButton.frame = CGRectMake(rand_x, rand_y, 80.0, 84.0);
        }
        else
        {
            NSMutableArray* mycoords = [self getGoodCoords:true width:130 height:150];
            rand_x = [mycoords[0] intValue];
            rand_y = [mycoords[1] intValue];
            crownButton.frame = CGRectMake(rand_x, rand_y, 130.0, 150.0);
        }
        
        crownButton.hidden = false;
        
        if ([crownSpawn_timer isValid])
        {
            [crownSpawn_timer invalidate];
        }
        
        grail_movements = 0;
        crownSpawn_timer = [NSTimer scheduledTimerWithTimeInterval: 1.5 target: self selector: @selector(hidecrownButton) userInfo: nil repeats: NO];
    }
    if (rand()%88 == 0 && ([UnusedDiamondObjects count] > 0))
    {
        NSUInteger randomIndex = arc4random() % [UnusedDiamondObjects count];
        NSNumber* objx = (NSNumber*)[UnusedDiamondObjects objectAtIndex:randomIndex];
        int thetag = [objx intValue];
        CGFloat destX = 0.0, destY = 0.0;
        
        object_count++;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            if (thetag == 1000) 
            {
                destX = 500; destY = 148;
            }
            
            if (thetag == 1001)
            {
                destX = 500; destY = 302;
            }
            
            if (thetag == 1002)
            {
                destX = -100; destY = 359;
            }
        }
        else
        {
            if (thetag == 1000)
            {
                destX = 900; destY = 341;
            }
            
            if (thetag == 1001)
            {
                destX = 900; destY = 524;
            }
            
            if (thetag == 1002)
            {
                destX = -200; destY = 711;
            }
        }
        
        [self MoveObject:thetag button_add:3 xpos:destX ypos:destY dur:4.5];
        [UnusedDiamondObjects removeObject:objx];
    }
    if (([defaults boolForKey:@"charm-powerup"] == true) && rand()%99 == 0) // lucky charm
    {
        grailButton.hidden = false;
        NSMutableArray* coords;
        int rand_x, rand_y;
        
        object_count++;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            coords = [self getGoodCoords:false width:57 height:89];
            rand_x = [coords[0] intValue];
            rand_y = [coords[1] intValue];
            grailButton.frame = CGRectMake(rand_x, rand_y, 57.0, 89.0);
        }
        else
        {
            coords = [self getGoodCoords:false width:126 height:177];
            rand_x = [coords[0] intValue];
            rand_y = [coords[1] intValue];
            grailButton.frame = CGRectMake(rand_x, rand_y, 126.0, 177.0);
        }
        
        if ([grailSpawn_timer isValid])
        {
            [grailSpawn_timer invalidate];
        }
        grail_movements = 0;
        grailSpawn_timer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(moveGrail:) userInfo:[NSString stringWithFormat:@"%d", (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)] repeats:YES];
    }
    
    if (secs == 0)
    {
        playing=false;
        [_timer invalidate];
        [crown_timer invalidate];
        [grailSpawn_timer invalidate];
        [grailGemSpawn_timer invalidate];
        [audioPlayer stop];
        [self reduceMultiplier];

        if (taps >= 100)
        {
            tapsText.frame = CGRectMake((tapsText.frame.origin.x+15), tapsText.frame.origin.y, tapsText.frame.size.width, tapsText.frame.size.height);
            staticTapsLabel.frame = CGRectMake((staticTapsLabel.frame.origin.x+17), staticTapsLabel.frame.origin.y, staticTapsLabel.frame.size.width, staticTapsLabel.frame.size.height);
        }
        if (taps >= 1000)
        {
            tapsText.frame = CGRectMake((tapsText.frame.origin.x+10), tapsText.frame.origin.y, tapsText.frame.size.width, tapsText.frame.size.height);
            staticTapsLabel.frame = CGRectMake((staticTapsLabel.frame.origin.x+7), staticTapsLabel.frame.origin.y, staticTapsLabel.frame.size.width, staticTapsLabel.frame.size.height);
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                tapsText.frame = CGRectMake((tapsText.frame.origin.x+15), tapsText.frame.origin.y, tapsText.frame.size.width, tapsText.frame.size.height);
                staticTapsLabel.frame = CGRectMake((staticTapsLabel.frame.origin.x+15), staticTapsLabel.frame.origin.y, staticTapsLabel.frame.size.width, staticTapsLabel.frame.size.height);
            }
        }
        
        if (taps >= 10 && taps < 100)
        {
            tapsText.frame = CGRectMake((tapsText.frame.origin.x+10), tapsText.frame.origin.y, tapsText.frame.size.width, tapsText.frame.size.height);
            staticTapsLabel.frame = CGRectMake((staticTapsLabel.frame.origin.x+10), staticTapsLabel.frame.origin.y, staticTapsLabel.frame.size.width, staticTapsLabel.frame.size.height);
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                tapsText.frame = CGRectMake((tapsText.frame.origin.x-17), tapsText.frame.origin.y, tapsText.frame.size.width, tapsText.frame.size.height);
                staticTapsLabel.frame = CGRectMake((staticTapsLabel.frame.origin.x-17), staticTapsLabel.frame.origin.y, staticTapsLabel.frame.size.width, staticTapsLabel.frame.size.height);
            }
        }
        
        if (taps < 10)
        {
            tapsText.frame = CGRectMake((tapsText.frame.origin.x-7), tapsText.frame.origin.y, tapsText.frame.size.width, tapsText.frame.size.height);
            staticTapsLabel.frame = CGRectMake((staticTapsLabel.frame.origin.x-7), staticTapsLabel.frame.origin.y, staticTapsLabel.frame.size.width, staticTapsLabel.frame.size.height);
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                tapsText.frame = CGRectMake((tapsText.frame.origin.x-21), tapsText.frame.origin.y, tapsText.frame.size.width, tapsText.frame.size.height);
                staticTapsLabel.frame = CGRectMake((staticTapsLabel.frame.origin.x-21), staticTapsLabel.frame.origin.y, staticTapsLabel.frame.size.width, staticTapsLabel.frame.size.height);
            }
        }
        
        
        timerText.hidden = true;
        timesUpImg.hidden = false;
        
        for (UIButton* btn in BalloonButtons)
            btn.hidden = true;
        
        for (UIImageView* img in BalloonImages)
            img.hidden = true;
        
        for (UIButton* btn in DiamondButtons)
            btn.hidden = true;
        
        for (UIImageView* img in DiamondImages)
            img.hidden = true;
        
        for (UIImageView* img in [self.view subviews])
        {
            if (img.tag > 30000)
                img.hidden = true;
        }
        
        for (UIButton* btn in [self.view subviews])
        {
            if (btn.tag > 45000)
                btn.hidden = true;
        }
        
        crownButton.hidden = true;
        grailButton.hidden = true;
        multiplierLabel.hidden = true;
        
        if (inDiamond)
        {
            [self exitDiamondWorld];
            [_timer invalidate];
        }
        
        int oldHS = (int)theHS;
        if (taps > oldHS) // new High score
        {
            [defaults setInteger:taps forKey:@"highscore"];
            [defaults synchronize];
            NSString* freshHS = [NSString stringWithFormat:@"Highscore: %d", taps];
            highscoreText.text = freshHS;
            hiscoreImg.hidden = false;
            
            if (is_sound_en)
                AudioServicesPlaySystemSound(HighscoreSoundID);
        }
        
        backButton.hidden = false;
        [NSTimer scheduledTimerWithTimeInterval:1.5
                                         target:self
                                       selector:@selector(enableBackButton)
                                       userInfo:nil
                                        repeats:NO];
        share1.hidden = false;
        share2.hidden = false;
        shareFB.hidden = false;
        shareTWT.hidden = false;
        
        NSString* LBid = @"";
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            LBid = @"TapTitan_Phone";
        }
        else
        {
            LBid = @"TapTitan_Tablet";
        }
        
        if (object_count == 0)
        {
            if ([[GCHelper defaultHelper] reportAchievementIdentifier:@"TapTitan_WhatIsLuck" percentComplete:100.0])
            {
                [self addPoints:10];
            }
        }
        
        if (object_count == object_obtained)
        {
            if ([[GCHelper defaultHelper] reportAchievementIdentifier:@"TapTitan_DontGetCaughtSlipping" percentComplete:100.0])
            {
                [self addPoints:10];
            }
        }
        if (object_obtained == 0 && taps >= 200)
        {
            if ([[GCHelper defaultHelper] reportAchievementIdentifier:@"TapTitan_TitanResilience" percentComplete:100.0])
            {
                [self addPoints:10];
            }
        }
        
        [self addTapCredit:taps];
        
        int64_t thescore = (int64_t)taps;
        [[GCHelper defaultHelper] reportScore:thescore forLeaderboardID:LBid];
        gameAD.hidden = false;
    }
}

- (NSMutableArray*)getGoodCoords:(bool)tablet width:(int)width height:(int)height
{
    NSMutableArray* coords = [[NSMutableArray alloc] init];
    int screenHeight = (int)[[UIScreen mainScreen] bounds].size.height;
    int rand_x, rand_y = 0;
    
    if (tablet)
    {
        rand_x = arc4random() % (768 - width); // 0-638, 768-190 (width of crown)
        rand_y = arc4random() % (screenHeight - height); // device height-210 (height of crown)
        
        if ((rand_x > 0 && rand_x < 768) && (rand_y > (305 - height) && rand_y < (570 + height)))// bad spot
        {
            return [self getGoodCoords:true width:width height:height];
        }
    }
    else
    {
        rand_x = arc4random() % (320 - width); // 0-240, 320-80 (width of crown)
        rand_y = arc4random() % (screenHeight - height); // device height-84 (height of crown)
        
        if ([[UIScreen mainScreen] bounds].size.height == 568 || [[UIScreen mainScreen] bounds].size.height == 1136 || [[UIScreen mainScreen] bounds].size.height == 960) // iphone 5 move shit down
        {
            if ((rand_x > 0 && rand_x < 266) && (rand_y > ((133 - height)+45) && rand_y < ((265 + height)+45)))// bad spot
            {
                return [self getGoodCoords:false width:width height:height];
            }
        }
        else
        {
            if ((rand_x > 0 && rand_x < 266) && (rand_y > (133 - height) && rand_y < (265 + height)))// bad spot
            {
                return [self getGoodCoords:false width:width height:height];
            }
        }

    }
    
    [coords addObject:[NSNumber numberWithInt:rand_x]];
    [coords addObject:[NSNumber numberWithInt:rand_y]];
    return coords;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // initializing vars
    taps=0;
    tap_multiplier=1;
    secs=30;
    secs_diamond=0;
    playing=true;
    text_moved=false;
    text_moved_10=false;
    text_moved_100=false;
    text_moved_1000=false;
    balloon_count = 0;
    object_count = 0;
    balloon_obtained = 0;
    crown_obtained = 0;
    diamond_obtained = 0;
    object_obtained = 0;
    obj_cycle = 0;
    start_tag=10000;
    start_tag_gr=20000;
    start_tag_gr_d=30000;
    start_tag_gr_d_btn=45000;
    grail_gems=0;
    max_grail_gems=0;
    secs_grail_gems=0;
    
    srand(time(NULL));
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    is_sound_en = [defaults boolForKey:@"sound"];
    is_music_en = [defaults boolForKey:@"music"];
    
    // setting up sounds
    NSURL* soundurl = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                              pathForResource:@"Click"
                                              ofType:@"wav"]];
    NSURL* soundurl_b = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"Pop"
                                                ofType:@"wav"]];
    NSURL* soundurl_d = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"Shining"
                                                ofType:@"wav"]];
    NSURL* soundurl_e = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"Ding"
                                                ofType:@"wav"]];
    NSURL* soundurl_f = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"Rock-tap"
                                                ofType:@"wav"]];
    NSURL* soundurl_g = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"Electrical-Sweep"
                                                ofType:@"wav"]];
    NSURL* soundurl_h = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"Unlocked"
                                                ofType:@"wav"]];
    NSURL* soundurl_j = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"Magicbell"
                                                ofType:@"wav"]];
    NSURL* soundurl_k = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:@"Gotitem"
                                                ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundurl, &ClickSoundID);
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundurl_b, &BalloonSoundID);
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundurl_d, &HighscoreSoundID);
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundurl_e, &DingSoundID);
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundurl_f, &RockTapSoundID);
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundurl_g, &RockCrushSoundID);
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundurl_h, &UnlockedSoundID);
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundurl_j, &GrailSoundID);
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundurl_k, &GrailGemSoundID);
    
    NSString* songName = (NSString*)[defaults objectForKey:@"track"];
    NSURL* soundurl_c = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                pathForResource:songName
                                                ofType:@"mp3"]];
    audioPlayer = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:soundurl_c
                   error:nil];
    audioPlayer.numberOfLoops=-1;
    
    if (is_music_en)
        [audioPlayer play];
    
    // highscore system
    theHS = [defaults integerForKey:@"highscore"];
    NSString* updatedHS = [NSString stringWithFormat:@"Highscore: %d", (int)theHS];
    highscoreText.text = updatedHS;
    
    // balloon aspect
    NSNumber* ballimg1 = [NSNumber numberWithInt:100];
    NSNumber* ballimg2 = [NSNumber numberWithInt:101];
    NSNumber* ballimg3 = [NSNumber numberWithInt:102];
    NSNumber* ballimg4 = [NSNumber numberWithInt:103];
    UnusedBalloonImgTags = [[NSMutableArray alloc] initWithObjects:ballimg1, ballimg2, ballimg3, ballimg4, nil];
    
    NSNumber* diamondimg1 = [NSNumber numberWithInt:1000];
    NSNumber* diamondimg2 = [NSNumber numberWithInt:1001];
    NSNumber* diamondimg3 = [NSNumber numberWithInt:1002];
    NSNumber* diamondtaps1 = [NSNumber numberWithInt:5];
    NSNumber* diamondtaps2 = [NSNumber numberWithInt:5];
    NSNumber* diamondtaps3 = [NSNumber numberWithInt:5];
    UnusedDiamondObjects = [[NSMutableArray alloc] initWithObjects: diamondimg1, diamondimg2, diamondimg3, nil];
    DiamondTaps = [[NSMutableArray alloc] initWithObjects:diamondtaps1, diamondtaps2, diamondtaps3, nil];
    

    // setup and start timer
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                              target:self
                                            selector:@selector(updateTime:)
                                            userInfo:nil
                                             repeats:YES];
    
    // some visual adjustments
    brokenDiamond = [UIImage imageNamed:@"cracked_diamond.png"];
    diamondWorldImg = [UIImage imageNamed:@"purple-magic.jpg"];
    defStaticTapsColor = staticTapsLabel.textColor;
    defMultiplyLabelColor = multiplierLabel.textColor;
    defBackButtonColor = backButton.backgroundColor;
    defHighscoreLabelColor = highscoreText.textColor;
    
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"GraphPaper" ofType:@"jpg"]];
    share1.backgroundColor = [UIColor colorWithPatternImage:image];
    share2.backgroundColor = [UIColor colorWithPatternImage:image];
    
    backButton.backgroundColor = [UIColor colorWithRed:110.0/255.0 green:127.0/255.0 blue:128.0/255.0 alpha:1.0];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        tapsText.font = FONT_PRICEDOWN(57);
    }
    else
    {
        tapsText.font = FONT_PRICEDOWN(130);
    }
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0 && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        tapsText.font = FONT_PRICEDOWN(56);
        staticTapsLabel.frame = CGRectMake((staticTapsLabel.frame.origin.x-3), staticTapsLabel.frame.origin.y, staticTapsLabel.frame.size.width, staticTapsLabel.frame.size.height);
        multiplierLabel.frame = CGRectMake((multiplierLabel.frame.origin.x-5), multiplierLabel.frame.origin.y, multiplierLabel.frame.size.width, multiplierLabel.frame.size.height);
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0 && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        tapsText.frame = CGRectMake(tapsText.frame.origin.x, (tapsText.frame.origin.y-4), tapsText.frame.size.width, tapsText.frame.size.height);
    }
    
    // setup the background
    [self setupBG];
    
    // fix for iphone 5 move shit down
    if ([[UIScreen mainScreen] bounds].size.height == 568 || [[UIScreen mainScreen] bounds].size.height == 1136 || [[UIScreen mainScreen] bounds].size.height == 960)
    {
        for (UIView* view in self.view.subviews)
        {
            if (view.tag != 59019 && view.tag != 127)
            {
                [view setFrame:CGRectMake(view.frame.origin.x, (view.frame.origin.y+45), view.frame.size.width, view.frame.size.height)];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showBanner:(NSString*)msg pnts:(int)pnts pad:(bool)pad
{
    UIView* view;
    if (pad)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(180, 30, 400, 85)];
    }
    else
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(35, 15, 250, 45)];
    }
    view.layer.shadowRadius = 4.0;
    view.layer.shadowOpacity = 1.0;
    view.layer.shadowOffset = CGSizeMake(0, 0);
    view.layer.borderWidth = 1.0;
    view.layer.borderColor = [UIColor blackColor].CGColor;
    view.tag = start_tag;
    
    UIImageView* img;
    if (pad)
    {
        img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 400, 85)];
    }
    else
    {
        img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 45)];
    }
    img.image = [UIImage imageNamed:@"banner.jpg"];
    img.tag = (start_tag+1);
    
    UILabel* msgLbl;
    if (pad)
    {
        msgLbl = [[UILabel alloc] initWithFrame:CGRectMake(51, 24, 325, 35)];
        msgLbl.font = [UIFont fontWithName:@"Futura" size:20.0];
    }
    else
    {
        msgLbl = [[UILabel alloc] initWithFrame:CGRectMake(31, 12, 218, 21)];
        msgLbl.font = [UIFont fontWithName:@"Futura" size:12.0];
    }
    msgLbl.text = msg;
    msgLbl.backgroundColor = [UIColor clearColor];
    msgLbl.tag = (start_tag+2);
    
    /*UILabel* pntLbl = [[UILabel alloc] initWithFrame:CGRectMake(200, 12, 42, 21)];
    pntLbl.font = [UIFont systemFontOfSize:17.0];
    pntLbl.textColor = [UIColor lightGrayColor];
    pntLbl.backgroundColor = [UIColor clearColor];
    pntLbl.text = [NSString stringWithFormat:@"%d", pnts];
    pntLbl.textAlignment = NSTextAlignmentCenter;
    pntLbl.tag = (start_tag+3);*/
    
    UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn addTarget:self action:@selector(closeBanner) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    if (pad)
    {
        
        closeBtn.frame = CGRectMake(360, -2, 44, 44);
    }
    else
    {
        closeBtn.frame = CGRectMake(229, -1, 22, 22);
    }
    closeBtn.tag = (start_tag+4);
    
    [view addSubview:img];
    [view addSubview:msgLbl];
   /* if (pnts != -1)
    {
        [view addSubview:pntLbl];
    }*/
    [view addSubview:closeBtn];
    
    [self.view addSubview:view];
    start_tag += 5;
    if ([bannerTimer isValid])
    {
        [bannerTimer invalidate];
    }
    bannerTimer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(closeBanner) userInfo:nil repeats:YES];
}

- (void)closeBanner
{
    if (start_tag > 10000)
    {
        UIView* banner = [self.view viewWithTag:(start_tag-5)];
        [UIView animateWithDuration:0.7
                              delay:0.0
                            options: UIViewAnimationOptionAllowAnimatedContent
                         animations:^{
                             [banner setAlpha:0.0];
                         }
                         completion:^(BOOL finished){
                             if (finished)
                             {
                                 [banner removeFromSuperview];
                             }
                         }];
        
        start_tag -= 5;
    }
    
    if ([bannerTimer isValid])
    {
        [bannerTimer invalidate];
        bannerTimer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(closeBanner) userInfo:nil repeats:YES];
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    
    if (playing)
    {
        taps += ([touches count]*tap_multiplier);
        [self updateTapsText];
    }
    
    for (UIButton *button in BalloonButtons)
    {
        if ([button.layer.presentationLayer hitTest:touchLocation])
        {
            NSDate* tempDate = [NSDate dateWithTimeIntervalSinceNow:1.0]; // these 2 lines make next fire a sec so that it wont appear like you only got +2 secs
            [_timer setFireDate:tempDate];
            secs += 3;
            
            NSString* updatedTime = [NSString stringWithFormat:@"%d", secs];
            timerText.text = updatedTime;
            
            if (is_sound_en)
                AudioServicesPlaySystemSound(BalloonSoundID);
            
            UIImageView* clickedImg = (UIImageView*)[self.view viewWithTag:(button.tag-4)];
            button.hidden = false;
            clickedImg.hidden = false;
            [self MoveObject:(int)clickedImg.tag button_add:4 xpos:-700.0 ypos:700.0 dur:0.0]; // get off screen
            addedTimeImg.hidden = false;
            [NSTimer scheduledTimerWithTimeInterval: 2.5 target: self selector: @selector(hideaddedSecondsLabel) userInfo: nil repeats: NO];
            
            object_obtained++;
            balloon_obtained++;
            if (balloon_obtained == 4)
            {
                if ([[GCHelper defaultHelper] reportAchievementIdentifier:@"TapTitan_HappyBirthdayToYou" percentComplete:100.0])
                {
                    [self addPoints:5];
                }
            }
            
            if (obj_cycle == 0) // for One After Another ach
            {
                obj_cycle++;
            }
            else
            {
                obj_cycle = 1;
            }
            
            break;
        }
    }
    for (UIButton* button in DiamondButtons)
    {
        if ([button.layer.presentationLayer hitTest:touchLocation])
        {
            int tapsDone = 0;
            int someidx = 0;
            
            if (button.tag == 1004)
            {
                someidx=1;
            }
            if (button.tag == 1005)
            {
                someidx=2;
            }
            
            tapsDone = [DiamondTaps[someidx] intValue];
            if (tapsDone > 0)
            {
                tapsDone--;
                [DiamondTaps replaceObjectAtIndex:someidx withObject:[NSNumber numberWithInt:tapsDone]];
                
                if (tapsDone == 0)
                {
                    object_obtained++;
                    diamond_obtained++;
                    
                    if (is_sound_en)
                        AudioServicesPlaySystemSound(RockCrushSoundID);
                    
                    if (!inDiamond)
                    {
                        inDiamond = true;
                        [_timer invalidate];
                        _timer = nil;
                        _timer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                                  target:self
                                                                selector:@selector(updateTime:)
                                                                userInfo:nil
                                                                 repeats:YES];
                        multiTapImg.hidden = false;
                        [tapsText setTextColor:[UIColor colorWithRed:230.0 green:230.0 blue:230.0 alpha:1.0]];
                        staticTapsLabel.textColor = [UIColor redColor];
                        highscoreText.textColor = defHighscoreLabelColor;
                        multiplierLabel.textColor = defMultiplyLabelColor;
                        screenPH.image = diamondWorldImg;
                        [screenPH setAlpha:1.0];
                        screenPH.multipleTouchEnabled = true;
                        [NSTimer scheduledTimerWithTimeInterval:4.0
                                                         target:self
                                                       selector:@selector(hideMultitap)
                                                       userInfo:nil
                                                        repeats:NO];
                    }
                    secs_diamond += 5;
                    
                    
                    [DiamondImages[someidx] setImage:brokenDiamond];
                    [[DiamondButtons[someidx] layer] removeAllAnimations];
                    [[DiamondImages[someidx] layer] removeAllAnimations];
                    [DiamondImages[someidx] setCenter:touchLocation];

                    NSString* _str = [NSString stringWithFormat:@"Diamond%d", (someidx+1)];
                    
                    [NSTimer scheduledTimerWithTimeInterval:1.0
                                                     target:self
                                                   selector:@selector(hideDiamond:)
                                                   userInfo:_str
                                                    repeats:NO];
                    
                    if (diamond_obtained == 3)
                    {
                        if ([[GCHelper defaultHelper] reportAchievementIdentifier:@"TapTitan_DreamsDoComeTrue" percentComplete:100.0])
                        {
                            [self addPoints:20];
                        }
                    }
                    
                    if (obj_cycle == 2) // for One After Another ach
                    {
                        obj_cycle = 0;
                        if ([[GCHelper defaultHelper] reportAchievementIdentifier:@"TapTitan_OneAfterAnother" percentComplete:100.0])
                        {
                            [self addPoints:15];
                        }
                    }
                    else
                    {
                        obj_cycle = 0;
                    }
                    
                    if (secs <= 3)
                    {
                        if ([[GCHelper defaultHelper] reportAchievementIdentifier:@"TapTitan_AFinalEffort" percentComplete:100.0])
                        {
                            [self addPoints:15];
                        }
                    }
                }
                else
                {
                    if (is_sound_en)
                        AudioServicesPlaySystemSound(RockTapSoundID);
                }
            }
        }
    }
}

- (void)enableBackButton
{
    backButton.enabled = true;
    backButton.backgroundColor = defBackButtonColor;
}

- (void)hideaddedSecondsLabel
{
    addedTimeImg.hidden = true;
}

- (void)hidecrownButton
{
    crownButton.hidden = true;
}

- (void)grailGem_clicked:(UIButton*)sender
{
    taps += tap_multiplier;
    taps += 40;
    [self updateTapsText];
    
    sender.hidden = true;
    
    if (is_sound_en)
        AudioServicesPlaySystemSound(GrailGemSoundID);
    
    int screenHeight = (int)[[UIScreen mainScreen] bounds].size.height;
    
    [self hideAllGrailGemTexts];
    
    UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"40.png"]];
    img.tag = (start_tag_gr_d+1);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [img setFrame:CGRectMake(0, 0, 75, 45)];
    }
    else
    {
        [img setFrame:CGRectMake(0, 0, 125, 85)];
    }
    [img setCenter:sender.frame.origin];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (img.frame.origin.x < 0)
        {
            [img setFrame:CGRectMake(0, img.frame.origin.y, 75, 45)];
        }
        if (img.frame.origin.y < 0)
        {
            [img setFrame:CGRectMake(img.frame.origin.x, 0, 75, 45)];
        }
        if (img.frame.origin.x > (320 - 75))
        {
            [img setFrame:CGRectMake((320 - 75), img.frame.origin.y, 75, 45)];
        }
        if (img.frame.origin.y > (screenHeight - 45))
        {
            [img setFrame:CGRectMake(img.frame.origin.x, (screenHeight - 45), 75, 45)];
        }
    }
    else
    {
        if (img.frame.origin.x < 0)
        {
            [img setFrame:CGRectMake(0, img.frame.origin.y, 125, 85)];
        }
        if (img.frame.origin.y < 0)
        {
            [img setFrame:CGRectMake(img.frame.origin.x, 0, 125, 85)];
        }
        if (img.frame.origin.x > (768 - 125))
        {
            [img setFrame:CGRectMake((768 - 125), img.frame.origin.y, 125, 80)];
        }
        if (img.frame.origin.y > (screenHeight - 85))
        {
            [img setFrame:CGRectMake(img.frame.origin.x, (screenHeight - 85), 125, 85)];
        }
    }
    [self.view addSubview:img];
    
    start_tag_gr_d++;
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hideGrailGemText:) userInfo:[NSString stringWithFormat:@"%d", (int)img.tag] repeats:NO];
}

- (void)hideDiamond:(NSTimer*)theTimer
{
    NSString* theDiamond = [theTimer userInfo];
    int idx=0;

    if ([theDiamond isEqualToString:@"Diamond2"])
    {
        idx=1;
    }
    if ([theDiamond isEqualToString:@"Diamond3"])
    {
        idx=2;
    }
    
    [self MoveObject:(1000+idx) button_add:3 xpos:-700.0 ypos:700.0 dur:0.0];
    [DiamondImages[idx] setHidden:true];
    [DiamondButtons[idx] setHidden:true];
}

- (void)hideMultitap
{
    multiTapImg.hidden = true;
}

- (void)spawnGrailGem
{
    if ((grail_gems < max_grail_gems) && (secs_grail_gems > 0))
    {
        secs_grail_gems--;
        srand(time(NULL));
        int rand_gems = arc4random()%5;
        NSLog(@"Random Gems: %d", rand_gems);
        int rand_x, rand_y;
        for (int i=0; i<rand_gems; i++)
        {
            if (arc4random()%2 == 0)
            {
                if (grail_gems < max_grail_gems)
                {
                    UIButton* gem = [UIButton buttonWithType:UIButtonTypeCustom];
                    gem.tag = (start_tag_gr_d_btn+1);
                    [gem addTarget:self action:@selector(grailGem_clicked:) forControlEvents:UIControlEventTouchDown];
                    [gem setBackgroundImage:[UIImage imageNamed:@"Gem.png"] forState:UIControlStateNormal];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                    {
                        NSMutableArray* coords = [self getGoodCoords:false width:64 height:64];
                        rand_x = [coords[0] intValue];
                        rand_y = [coords[1] intValue];
                        gem.frame = CGRectMake(rand_x, rand_y, 64, 64);
                    }
                    else
                    {
                        NSMutableArray* coords = [self getGoodCoords:false width:112 height:112];
                        rand_x = [coords[0] intValue];
                        rand_y = [coords[1] intValue];
                        gem.frame = CGRectMake(rand_x, rand_y, 112, 112);
                    }
                    [self.view addSubview:gem];
                    start_tag_gr_d_btn++;
                    grail_gems++;
                    
                    [NSTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(hideGem:) userInfo:[NSString stringWithFormat:@"%d", (int)gem.tag] repeats:NO];
                }
                else
                {
                    break;
                }
            }
        }
    }
    else
    {
        [grailGemSpawn_timer invalidate];
    }
}

- (void)hideGem:(NSTimer*)timer
{
    int theid = [[timer userInfo] intValue];
    UIView* view = [self.view viewWithTag:theid];
    [view removeFromSuperview];
}

- (void)moveGrail:(NSTimer*)timer
{
    int uinfo = [[timer userInfo] intValue];
    int width, height;
    int rand_x, rand_y;
    bool pad = false;
    
    if (uinfo == 0) // phone
    {
        width = 57;
        height = 89;
    }
    else
    {
        width = 126;
        height = 177;
        pad = true;
    }
    
    NSMutableArray* arr = [self getGoodCoords:pad width:width height:height];
    rand_x = [arr[0] intValue];
    rand_y = [arr[1] intValue];
    [grailButton setFrame:CGRectMake(rand_x, rand_y, width, height)];
    
    grail_movements++;
    if (grail_movements == 5)
    {
        [grailSpawn_timer invalidate];
        grailButton.hidden = true;
    }
}

- (void)hideGrailText:(NSTimer*)timer
{
    int thetag = [[timer userInfo] intValue];
    UIView* view = [self.view viewWithTag:thetag];
    [view removeFromSuperview];
}

- (void)hideGrailGemText:(NSTimer*)timer
{
    int thetag = [[timer userInfo] intValue];
    UIView* view = [self.view viewWithTag:thetag];
    [view removeFromSuperview];
}

- (void)hideAllGrailGemTexts
{
    for (UIView* view in [self.view subviews])
    {
        if (view.tag > 30000 && view.tag < 45000)
        {
            view.hidden = true;
        }
    }
}

- (void)exitDiamondWorld
{
    inDiamond = false;
    screenPH.multipleTouchEnabled = false;
    [tapsText setTextColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
    staticTapsLabel.textColor = defStaticTapsColor;
    secs_diamond=0;
    [_timer invalidate];
    _timer = nil;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                              target:self
                                            selector:@selector(updateTime:)
                                            userInfo:nil
                                             repeats:YES];
    [self setupBG];
}

- (void)reduceMultiplier
{
    tap_multiplier = 1;
    
    multiplierLabel.hidden = true;
    if (text_moved)
    {
        text_moved = false;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            tapsText.frame = CGRectMake((tapsText.frame.origin.x+15), tapsText.frame.origin.y, tapsText.frame.size.width, tapsText.frame.size.height);
            staticTapsLabel.frame = CGRectMake((staticTapsLabel.frame.origin.x+17), staticTapsLabel.frame.origin.y, staticTapsLabel.frame.size.width, staticTapsLabel.frame.size.height);
        }
        else
        {
            tapsText.frame = CGRectMake((tapsText.frame.origin.x+30), tapsText.frame.origin.y, tapsText.frame.size.width, tapsText.frame.size.height);
            staticTapsLabel.frame = CGRectMake((staticTapsLabel.frame.origin.x+30), staticTapsLabel.frame.origin.y, staticTapsLabel.frame.size.width, staticTapsLabel.frame.size.height);
        }
    }
}

- (void)setupBG
{
    NSString* bg = (NSString*)[defaults objectForKey:@"background"];
    int def_os = 1;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        def_os = 3;
    }
    
    if ([bg isEqualToString:@"null"] == false)
    {
        screenPH.image = [UIImage imageNamed:bg];
        if ([bg isEqualToString:@"HouseOfCards.jpg"])
        {
            [screenPH setAlpha:0.85];
            [tapsText setTextColor:[UIColor colorWithRed:235.0/255.0 green:5.0/255.0 blue:0.0/255.0 alpha:1.0]];
            [staticTapsLabel setTextColor:[UIColor colorWithRed:20.0/255.0 green:180.0/255.0 blue:40.0/255.0 alpha:1.0]];
            [multiplierLabel setTextColor:[UIColor colorWithRed:255.0/255.0 green:165.0/255.0 blue:0.0/255.0 alpha:1.0]];
            [highscoreText setTextColor:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]];
            [self addShadowToLabel:timerText rad:1 os:def_os];
            [self addShadowToLabel:staticTapsLabel rad:1 os:def_os];
            [self addShadowToLabel:multiplierLabel rad:1 os:def_os];
            [self addShadowToLabel:tapsText rad:1 os:def_os];
            [highscoreText setTextColor:[UIColor colorWithRed:251.0/255.0 green:180.0/255.0 blue:0.0/255.0 alpha:1.0]];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                [self addShadowToLabel:highscoreText rad:3 os:def_os];
            }
            else
            {
                highscoreText.layer.shadowColor = [UIColor blackColor].CGColor;
                highscoreText.layer.shadowOffset = CGSizeMake(0, 1);
                highscoreText.layer.shadowOpacity = 1.0;
                highscoreText.layer.shadowRadius = 1.0;
            }
            hiscoreImg.layer.shadowColor = [UIColor blackColor].CGColor;
            hiscoreImg.layer.shadowOffset = CGSizeMake(0, 0);
            hiscoreImg.layer.shadowOpacity = 1.0;
            hiscoreImg.layer.shadowRadius = 3.0;
            hiscoreImg.image = [UIImage imageNamed:@"hiscore-2.png"];
        }
        if ([bg isEqualToString:@"TasteOfPower.jpg"])
        {
            [staticTapsLabel setTextColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]];
            [tapsText setTextColor:[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]];
            [multiplierLabel setTextColor:[UIColor colorWithRed:0.0/255.0 green:170.0/255.0 blue:0.0/255.0 alpha:1.0]];
            [self addShadowToLabel:timerText rad:1 os:def_os];
            [self addShadowToLabel:tapsText rad:1 os:def_os];
            [self addShadowToLabel:staticTapsLabel rad:1 os:def_os];
            [self addShadowToLabel:multiplierLabel rad:1 os:def_os];
            [highscoreText setTextColor:[UIColor colorWithRed:250.0/255.0 green:224.0/255.0 blue:30.0/255.0 alpha:1.0]];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                [self addShadowToLabel:highscoreText rad:3 os:def_os];
            }
        }
        if ([bg isEqualToString:@"MagicGrass.jpg"])
        {
            [multiplierLabel setTextColor:[UIColor colorWithRed:190.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]];
            hiscoreImg.image = [UIImage imageNamed:@"hiscore-2.png"];
        }
        if ([bg isEqualToString:@"Throne.jpg"])
        {
            [tapsText setTextColor:[UIColor colorWithRed:235.0/255.0 green:155.0/255.0 blue:50.0/255.0 alpha:1.0]];
            [staticTapsLabel setTextColor:[UIColor colorWithRed:20.0/255.0 green:180.0/255.0 blue:40.0/255.0 alpha:1.0]];
            [highscoreText setTextColor:[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]];
            [self addShadowToLabel:timerText rad:1 os:def_os];
            [self addShadowToLabel:staticTapsLabel rad:1 os:def_os];
            [self addShadowToLabel:tapsText rad:1 os:def_os];
            [self addShadowToLabel:highscoreText rad:1 os:def_os];
        }
        if ([bg isEqual:@"LostCity.jpg"])
        {
            hiscoreImg.image = [UIImage imageNamed:@"hiscore-2.png"];
            [highscoreText setTextColor:[UIColor orangeColor]];
            [tapsText setTextColor:[UIColor colorWithRed:255.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:1.0]];
            [staticTapsLabel setTextColor:[UIColor yellowColor]];
            [timerText setTextColor:[UIColor colorWithRed:0.0/255.0 green:225.0/255.0 blue:15.0/255.0 alpha:1.0]];
            [self addShadowToLabel:timerText rad:1 os:def_os];
            [self addShadowToLabel:highscoreText rad:1 os:def_os];
            [self addShadowToLabel:staticTapsLabel rad:1 os:def_os];
            [self addShadowToLabel:tapsText rad:1 os:def_os];
        }
    }
    else
    {
        screenPH.image = [UIImage imageNamed:@"Paper.png"];
    }
}

- (void)MoveObject:(int)imgTag button_add:(int)button_add xpos:(CGFloat)xpos ypos:(CGFloat)ypos dur:(CGFloat)dur
{
    UIImageView* Object = (UIImageView*)[self.view viewWithTag:imgTag];
    UIButton* ObjectButton = (UIButton*)[self.view viewWithTag:(imgTag+button_add)];
    Object.hidden = false;
    ObjectButton.hidden = false;
    
    CGRect frame = Object.frame;
    CGRect frame_b = ObjectButton.frame;
    frame.origin.x = xpos;
    frame.origin.y = ypos;
    frame_b.origin.x = xpos;
    frame_b.origin.y = ypos;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:dur];
    Object.frame = frame;
    ObjectButton.frame = frame_b;
    [UIView commitAnimations];
}

- (void)addPoints:(int)modifier
{
    if (![[GCHelper defaultHelper] isPlayerAuthenticated])
    {
        return;
    }
    int curr_cred = (int)[defaults integerForKey:@"credits"];
    int curr_pnts = (int)[defaults integerForKey:@"points"];
    if (curr_pnts >= MAX_POINTS) { return; }
    [defaults setInteger:(curr_pnts+modifier) forKey:@"points"];
    [defaults synchronize];
    
    bool ipad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    if (curr_pnts < 45 && (curr_pnts+modifier) >= 45 && curr_cred >= 1500)
    {
        [self showBanner:@"Unlocked: New Background" pnts:-1 pad:ipad];
    }
    else if (curr_pnts < 60 && (curr_pnts+modifier) >= 60 && curr_cred >= 2500)
    {
        [self showBanner:@"Unlocked: New Background" pnts:-1 pad:ipad];
    }
    else if (curr_pnts < 80 && (curr_pnts+modifier) >= 80 && curr_cred >= 5000)
    {
        [self showBanner:@"Unlocked: New Background" pnts:-1 pad:ipad];
    }
    else if (curr_pnts < 100 && (curr_pnts+modifier) >= 100 && curr_cred >= 8500)
    {
        [self showBanner:@"Unlocked: New Background" pnts:-1 pad:ipad];
    }
    else if (curr_pnts < 120 && (curr_pnts+modifier) >= 120 && curr_cred >= 12000)
    {
        [self showBanner:@"Unlocked: New Track" pnts:-1 pad:ipad];
    }
    else
    {
        return;
    }
    
    if (is_sound_en)
        AudioServicesPlaySystemSound(UnlockedSoundID);
}

- (void)addTapCredit:(int)modifier
{
    int curr_pnts = (int)[defaults integerForKey:@"points"];
    int curr_cred = (int)[defaults integerForKey:@"credits"];
    [defaults setInteger:(curr_cred+modifier) forKey:@"credits"];
    [defaults synchronize];

    bool ipad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    if (curr_cred < 1500 && (curr_cred+modifier) >= 1500 && curr_pnts >= 45)
    {
        [self showBanner:@"Unlocked: New Background" pnts:-1 pad:ipad];
    }
    else if (curr_cred < 2500 && (curr_cred+modifier) >= 2500 && curr_pnts >= 60)
    {
        [self showBanner:@"Unlocked: New Background" pnts:-1 pad:ipad];
    }
    else if (curr_cred < 5000 && (curr_cred+modifier) >= 5000 && curr_pnts >= 80)
    {
        [self showBanner:@"Unlocked: New Background" pnts:-1 pad:ipad];
    }
    else if (curr_cred < 8500 && (curr_cred+modifier) >= 8500 && curr_pnts >= 100)
    {
        [self showBanner:@"Unlocked: New Background" pnts:-1 pad:ipad];
    }
    else if (curr_cred < 12000 && (curr_cred+modifier) >= 12000 && curr_pnts >= 120)
    {
        [self showBanner:@"Unlocked: New Track" pnts:-1 pad:ipad];
    }
    else
    {
        return;
    }
    
    if (is_sound_en)
        AudioServicesPlaySystemSound(UnlockedSoundID);
}

- (void)addShadowToLabel:(UILabel*)label rad:(int)rad os:(CGFloat)os
{
    label.layer.shadowRadius = rad;
    label.layer.shadowOpacity = 1.0;
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(os, os);
}

- (void)updateTapsText
{
    NSString* updatedText = [NSString stringWithFormat:@"%d", taps];
    tapsText.text = updatedText;
    
    if (taps >= 200)
    {
        if ([[GCHelper defaultHelper] reportAchievementIdentifier:@"TapTitan_NoviceTapper" percentComplete:100.0])
        {
            [self addPoints:5];
        }
    }
    if (taps >= 300)
    {
        if ([[GCHelper defaultHelper] reportAchievementIdentifier:@"TapTitan_IntermediateTapper" percentComplete:100.0])
        {
            [self addPoints:10];
        }
    }
    if (taps >= 500)
    {
        if ([[GCHelper defaultHelper] reportAchievementIdentifier:@"TapTitan_ExpertTapper" percentComplete:100.0])
        {
            [self addPoints:15];
        }
    }
    if (taps >= 650)
    {
        if ([[GCHelper defaultHelper] reportAchievementIdentifier:@"TapTitan_MasterTapper" percentComplete:100.0])
        {
            [self addPoints:20];
        }
    }
    if (taps >= 900)
    {
        if ([[GCHelper defaultHelper] reportAchievementIdentifier:@"TapTitan_ATitanHasBeenBorn" percentComplete:100.0])
        {
            [self addPoints:30];
        }
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (taps >= 10 && !text_moved_10)
        {
            text_moved_10 = true;
            tapsText.frame = CGRectMake((tapsText.frame.origin.x-11), tapsText.frame.origin.y, tapsText.frame.size.width, tapsText.frame.size.height);
        }
        if (taps >= 100 && !text_moved_100)
        {
            text_moved_100 = true;
            tapsText.frame = CGRectMake((tapsText.frame.origin.x-8), tapsText.frame.origin.y, tapsText.frame.size.width, tapsText.frame.size.height);
        }
        if (taps >= 1000 && !text_moved_1000)
        {
            text_moved_1000 = true;
            tapsText.font = FONT_PRICEDOWN(53);
            tapsText.frame = CGRectMake((tapsText.frame.origin.x-8), (tapsText.frame.origin.y-2), tapsText.frame.size.width, tapsText.frame.size.height);
        }
    }
    else
    {
        if (taps >= 10 && !text_moved_10)
        {
            text_moved_10 = true;
            tapsText.frame = CGRectMake((tapsText.frame.origin.x-20), tapsText.frame.origin.y, tapsText.frame.size.width, tapsText.frame.size.height);
        }
        if (taps >= 100 && !text_moved_100)
        {
            text_moved_100 = true;
            tapsText.frame = CGRectMake((tapsText.frame.origin.x-28), tapsText.frame.origin.y, tapsText.frame.size.width, tapsText.frame.size.height);
        }
        if (taps >= 1000 && !text_moved_1000)
        {
            text_moved_1000 = true;
            tapsText.frame = CGRectMake((tapsText.frame.origin.x-25), tapsText.frame.origin.y, tapsText.frame.size.width, tapsText.frame.size.height);
        }
    }
}

- (IBAction)returnButton_pressed:(id)sender {
    if (is_sound_en)
        AudioServicesPlaySystemSound(ClickSoundID);
}

- (IBAction)crownButton_pressed:(id)sender {
    if (playing)
    {
        taps += tap_multiplier; // a crown will only be tapped once, multiple fingers can not affect this
        [self updateTapsText];
        
        tap_multiplier++;
        crownButton.hidden = true;
        NSString* label_txt = [NSString stringWithFormat:@"(X%d)", tap_multiplier];
        
        if (tap_multiplier == 3)
        {
            if ([[GCHelper defaultHelper] reportAchievementIdentifier:@"TapTitan_TripleTheFun" percentComplete:100.0])
            {
                [self addPoints:10];
            }
        }
        if (tap_multiplier == 4)
        {
            if ([[GCHelper defaultHelper] reportAchievementIdentifier:@"TapTitan_StraightKings" percentComplete:100.0])
            {
                [self addPoints:20];
            }
        }
        if (tap_multiplier == 5)
        {
            if ([[GCHelper defaultHelper] reportAchievementIdentifier:@"TapTitan_FullHouse" percentComplete:100.0])
            {
                [self addPoints:30];
            }
        }
        
        if (!text_moved)
        {
            text_moved = true;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                tapsText.frame = CGRectMake((tapsText.frame.origin.x-15), tapsText.frame.origin.y, tapsText.frame.size.width, tapsText.frame.size.height);
                staticTapsLabel.frame = CGRectMake((staticTapsLabel.frame.origin.x-17), staticTapsLabel.frame.origin.y, staticTapsLabel.frame.size.width, staticTapsLabel.frame.size.height);
            }
            else
            {
                tapsText.frame = CGRectMake((tapsText.frame.origin.x-30), tapsText.frame.origin.y, tapsText.frame.size.width, tapsText.frame.size.height);
                staticTapsLabel.frame = CGRectMake((staticTapsLabel.frame.origin.x-30), staticTapsLabel.frame.origin.y, staticTapsLabel.frame.size.width, staticTapsLabel.frame.size.height);
            }
        }
        
        multiplierLabel.text = label_txt;
        multiplierLabel.hidden = false;
        
        if (is_sound_en)
            AudioServicesPlaySystemSound(DingSoundID);
        
        if ([crown_timer isValid])
            [crown_timer invalidate];
        
        crown_timer = [NSTimer scheduledTimerWithTimeInterval: 4.0 target: self selector: @selector(reduceMultiplier) userInfo: nil repeats: NO];
        
        object_obtained++;
        crown_obtained++;
        
        if (obj_cycle == 1) // for One After Another ach
        {
            obj_cycle++;
        }
        else
        {
            obj_cycle = 0;
        }
        
        if (crown_obtained == 3)
        {
            if ([[GCHelper defaultHelper] reportAchievementIdentifier:@"TapTitan_JustAPrince" percentComplete:100.0])
            {
                [self addPoints:5];
            }
        }
        if (crown_obtained == 6)
        {
            if ([[GCHelper defaultHelper] reportAchievementIdentifier:@"TapTitan_FitForAKing" percentComplete:100.0])
            {
                [self addPoints:10];
            }
        }
        if (crown_obtained == 9)
        {
            if ([[GCHelper defaultHelper] reportAchievementIdentifier:@"TapTitan_KingOfCrowns" percentComplete:100.0])
            {
                [self addPoints:20];
            }
        }
        
        if (inDiamond)
        {
            if ([[GCHelper defaultHelper] reportAchievementIdentifier:@"TapTitan_MagicalRealism" percentComplete:100.0])
            {
                [self addPoints:10];
            }
        }
    }
}

- (IBAction)grailButton_clicked:(id)sender {
    taps += tap_multiplier;
    taps += 100;
    [self updateTapsText];
    
    secs_grail_gems += 4;
    max_grail_gems += 10;
    object_obtained++;
    grailButton.hidden = true;
    
    if (is_sound_en)
        AudioServicesPlaySystemSound(GrailSoundID);
    
    int screenHeight = (int)[[UIScreen mainScreen] bounds].size.height;
    
    UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"100.png"]];
    img.tag = (start_tag_gr+1);
    start_tag_gr++;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [img setFrame:CGRectMake(0, 0, 125, 75)];
    }
    else
    {
        [img setFrame:CGRectMake(0, 0, 275, 150)];
    }
    [img setCenter:grailButton.frame.origin];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (img.frame.origin.x < 0)
        {
            [img setFrame:CGRectMake(0, img.frame.origin.y, 125, 75)];
        }
        if (img.frame.origin.y < 0)
        {
            [img setFrame:CGRectMake(img.frame.origin.x, 0, 125, 75)];
        }
        if (img.frame.origin.x > (320 - 125))
        {
            [img setFrame:CGRectMake((320 - 125), img.frame.origin.y, 125, 75)];
        }
        if (img.frame.origin.y > (screenHeight - 75))
        {
            [img setFrame:CGRectMake(img.frame.origin.x, (screenHeight - 75), 125, 75)];
        }
    }
    else
    {
        if (img.frame.origin.x < 0)
        {
            [img setFrame:CGRectMake(0, img.frame.origin.y, 275, 150)];
        }
        if (img.frame.origin.y < 0)
        {
            [img setFrame:CGRectMake(img.frame.origin.x, 0, 275, 150)];
        }
        if (img.frame.origin.x > (768 - 275))
        {
            [img setFrame:CGRectMake((768 - 275), img.frame.origin.y, 275, 150)];
        }
        if (img.frame.origin.y > (screenHeight - 150))
        {
            [img setFrame:CGRectMake(img.frame.origin.x, (screenHeight - 150), 275, 150)];
        }
    }
    [self.view addSubview:img];
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hideGrailText:) userInfo:[NSString stringWithFormat:@"%d", (int)img.tag] repeats:NO];
    
    if ([grailGemSpawn_timer isValid] == false)
    {
        grailGemSpawn_timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(spawnGrailGem) userInfo:nil repeats:YES];
    }
}


- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

- (IBAction)shareFB_pressed:(id)sender {
  //[[FacebookScorer sharedInstance] postToWallWithDialogNewHighscore:taps];
    NSString* desc = [NSString stringWithFormat:@"I just got a score of %d on Tap Titan, can you beat me?", taps];
        // Put together the dialog parameters
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"Tap Titan", @"name",
                                       @"Can you become the Tap Titan?", @"caption",
                                       desc, @"description",
                                       @"https://facebook.com/taptitanapp", @"link",
                                       @"http://i60.tinypic.com/2imb8yw.png", @"picture",
                                       nil];
        
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                       parameters:params
                          handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                              if (error) {
                                  NSString* errorStr = [NSString stringWithFormat:@"Error publishing story: %@", error.description];
                                  UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Facebook Error" message:errorStr delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
                                  [av show];
                              } else {
                                  if (result == FBWebDialogResultDialogNotCompleted) {
                                      // User canceled.
                                      NSLog(@"User cancelled.");
                                  } else {
                                      // Handle the publish feed callback
                                      NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                      
                                      if (![urlParams valueForKey:@"post_id"]) {
                                          // User canceled.
                                          NSLog(@"User cancelled.");
                                          
                                      } else {
                                          // User clicked the Share button
                                          NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                          NSLog(@"result %@", result);
                                          if ([[GCHelper defaultHelper] reportAchievementIdentifier:@"TapTitan_ToMyFacebookFriends" percentComplete:100.0])
                                          {
                                              [self addPoints:20];
                                          }
                                      }
                                  }
                              }
                          }];
}

- (IBAction)shareTWT_pressed:(id)sender {
    NSString* urlSTR_a = [NSString stringWithFormat:@"I scored a %d on Tap Titan! Can you beat me?", taps];
    NSString* urlSTR = [urlSTR_a stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString* finalURL = [NSString stringWithFormat:@"https://twitter.com/intent/tweet?text=%@&hashtags=taptitan", urlSTR];
    NSURL* twpage = [NSURL URLWithString:finalURL];
    if ([[GCHelper defaultHelper] reportAchievementIdentifier:@"TapTitan_ToMyTwitterBuds" percentComplete:100.0])
    {
        [self addPoints:20];
    }
    if ([[UIApplication sharedApplication] canOpenURL:twpage]) {
        [[UIApplication sharedApplication] openURL:twpage];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com"]];
    }
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [banner setAlpha:1];
    [UIView commitAnimations];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [banner setAlpha:0];
    [UIView commitAnimations];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (([[UIDevice currentDevice].systemVersion floatValue] < 7.0)) {}
    else {
        if (arc4random()%2==0)
        {
            UIViewController *destination = [segue destinationViewController];
            destination.interstitialPresentationPolicy = ADInterstitialPresentationPolicyAutomatic;
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
