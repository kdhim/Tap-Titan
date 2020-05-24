//
//  ViewController.m
//  Tap King
//
//  Created by kevin dhimitri on 7/10/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    start_tag = 10000;
    if ([[UIScreen mainScreen] bounds].size.height == 568 || [[UIScreen mainScreen] bounds].size.height == 1136 || [[UIScreen mainScreen] bounds].size.height == 960) // iphone 5 move shit down
    {
        for (UIView* view in self.view.subviews)
        {
            if (view.tag != 59012)
            {
                if (view.tag == 400 || view.tag == 401 || view.tag == 402)
                {
                    [view setFrame:CGRectMake(view.frame.origin.x, (view.frame.origin.y+30), view.frame.size.width, view.frame.size.height)];
                }
                else
                {
                    [view setFrame:CGRectMake(view.frame.origin.x, (view.frame.origin.y+45), view.frame.size.width, view.frame.size.height)];
                }
            }
        }
    }
    
    sound_en = [defaults boolForKey:@"sound"];
    
    NSURL* soundurl = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                              pathForResource:@"Click"
                                              ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundurl, &ClickSoundID);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        currentLeaderBoard = @"TapTitan_Phone";
    }
    else
    {
        currentLeaderBoard = @"TapTitan_Tablet";
    }
    
    [[GCHelper defaultHelper] authenticateLocalUserOnViewController:self setCallbackObject:self withPauseSelector:@selector(authenticationRequired)];
}

- (void)authenticationRequired {}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startButton_pressed:(id)sender {
    if (sound_en)
        AudioServicesPlaySystemSound(ClickSoundID);
}

- (IBAction)achievements_pressed:(id)sender {
    [[GCHelper defaultHelper] showAchievementsOnViewController:self];
}

- (IBAction)leaderboards_pressed:(id)sender {
    [[GCHelper defaultHelper] showLeaderboardOnViewController:self];
}

- (IBAction)returned:(UIStoryboardSegue*)segue { }

- (IBAction)fb_pressed:(id)sender {
    NSURL* fbpage = [NSURL URLWithString:@"fb://profile/889581584389006"];
    if ([[GCHelper defaultHelper] reportAchievementIdentifier:@"TapTitan_IAmALikeTitan" percentComplete:100.0])
    {
        [self addPoints:10];
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:fbpage]) {
        [[UIApplication sharedApplication] openURL:fbpage];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://facebook.com/TapTitanAPP"]];
    }
}

- (IBAction)twtr_pressed:(id)sender {
    NSURL* twpage = [NSURL URLWithString:@"https://twitter.com/taptitanapp"];
    if ([[UIApplication sharedApplication] canOpenURL:twpage]) {
        if ([[GCHelper defaultHelper] reportAchievementIdentifier:@"TapTitan_TakeUsToYourLeader" percentComplete:100.0])
        {
            [self addPoints:10];
        }
        [[UIApplication sharedApplication] openURL:twpage];
        } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com"]];
    }
}

- (IBAction)rateButton_pressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/tap-titan-exciting-fast-paced/id904859657?ls=1&mt=8"]];
    if ([[GCHelper defaultHelper] reportAchievementIdentifier:@"TapTitan_ImSeeingStars" percentComplete:100.0])
    {
        [self addPoints:10];
    }
}

- (IBAction)inviteButton_pressed:(id)sender {
    int hiscore = [defaults integerForKey:@"highscore"];
    NSString* msg = [NSString stringWithFormat:@"Come play Tap Titan! Can you out-tap my highscore of %d", hiscore];
    [FBWebDialogs
     presentRequestsDialogModallyWithSession:nil
     message:msg
     title:nil
     parameters:nil
     handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         if (error) {
             // Error launching the dialog or sending the request.
             NSLog(@"Error sending request.");
         } else {
             if (result == FBWebDialogResultDialogNotCompleted) {
                 // User clicked the "x" icon
                 NSLog(@"User canceled request.");
             } else {
                 // Handle the send request callback
                 NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                 if (![urlParams valueForKey:@"request"]) {
                     // User clicked the Cancel button
                     NSLog(@"User canceled request.");
                 } else {
                     // User clicked the Send button
                     NSString *requestID = [urlParams valueForKey:@"request"];
                     NSLog(@"Request ID: %@", requestID);
                     if ([[GCHelper defaultHelper] reportAchievementIdentifier:@"TapTitan_NowItsAParty" percentComplete:100.0])
                     {
                         [self addPoints:10];
                     }
                 }
             }
         }
     }];
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

- (void)addPoints:(int)modifier
{
    if (![[GCHelper defaultHelper] isPlayerAuthenticated])
    {
        return;
    }
    int curr_pnts = (int)[defaults integerForKey:@"points"];
    if (curr_pnts >= MAX_POINTS) { return; }
    [defaults setInteger:(curr_pnts+modifier) forKey:@"points"];
    [defaults synchronize];
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

@end
