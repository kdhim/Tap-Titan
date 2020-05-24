//
//  RewardsViewController.m
//  Tap Titan
//
//  Created by kevin dhimitri on 8/6/14.
//  Copyright (c) 2014 kevin dhimitri. All rights reserved.
//

#import "RewardsViewController.h"

@interface RewardsViewController ()

@end

@implementation RewardsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [scrollView setScrollEnabled:true];
        [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 750)];
        self.view = scrollView;
    }
    else
    {
        [scrollView setScrollEnabled:true];
        [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 1640)];
        self.view = scrollView;
    }
    
    defaults = [NSUserDefaults standardUserDefaults];
    int taps = [defaults integerForKey:@"credits"];
    int points = [defaults integerForKey:@"points"];
    sound_en = [defaults boolForKey:@"sound"];
    
    totalTaps.text = [NSString stringWithFormat:@"Taps: %d", taps];
    totalPoints.text = [NSString stringWithFormat:@"Points: %d", points];
    UIButton* some = (UIButton*)EnableButtons[1];
    unenabledColor = some.backgroundColor;
    unenabledTextColor = some.titleLabel.textColor;
    unenabledFont = some.font;
    enabledColor = unlockedEnable.backgroundColor;
    enabledTxtColor = unlockedEnable.titleLabel.textColor;
    
    if ([[GCHelper defaultHelper] isAchievementComplete:@"TapTitan_NowItsAParty"])
    {
        [self enableButton:1];
    }
    else
    {
        UIButton* btn = infoButtons[0];
        btn.hidden = false;
    }
    
    if (taps >= 1500 && points >= 45)
    {
        [self enableButton:2];
    }
    if (taps >= 2500 && points >= 65)
    {
        [self enableButton:3];
    }
    if (taps >= 5000 && points >= 80)
    {
        [self enableButton:4];
    }
    if (taps >= 8500 && points >= 100)
    {
        [self enableButton:5];
    }
    if (([[GCHelper defaultHelper] isAchievementComplete:@"TapTitan_ToMyFacebookFriends"]) || ([[GCHelper defaultHelper] isAchievementComplete:@"TapTitan_ToMyTwitterBuds"]))
    {
        [self enableButton:7];
    }
    else
    {
        UIButton* btn = infoButtons[1];
        btn.hidden = false;
    }
    
    if (taps >= 12000 && points >= 120)
    {
        [self enableButton:8];
    }
    
    if ([[GCHelper defaultHelper] isAchievementComplete:@"TapTitan_ImSeeingStars"])
    {
        if ([defaults boolForKey:@"charm-powerup"] == false)
        {
            [self enableButton:9];
        }
    }
    else
    {
        UIButton* btn = infoButtons[2];
        btn.hidden = false;
    }

    /*[self enableButton:1];
    [self enableButton:2];
    [self enableButton:3];
    [self enableButton:4];
    [self enableButton:5];
    [self enableButton:7];
    [self enableButton:8];*/
    
    int sel_bg = [self indexOfSelectedBG];
    int sel_tr = [self indexOfSelectedTrack];
    UIImageView* img1 = (UIImageView*)checkImages[sel_bg];
    UIImageView* img2 = (UIImageView*)checkImages[sel_tr];
    img1.hidden = false;
    img2.hidden = false;
    
    UIImageView* img3 = (UIImageView*)checkImages[9];
    if ([defaults boolForKey:@"charm-powerup"] == true)
    {
        img3.hidden = false;
    }
    else
    {
        img3.hidden = true;
    }
    
    NSURL* soundurl = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                              pathForResource:@"Click"
                                              ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundurl, &ClickSoundID);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)enableButton:(int)idx
{
    UIButton* btn = (UIButton*)[EnableButtons objectAtIndex:idx];
    btn.backgroundColor = enabledColor;
    [btn setTitleColor:enabledTxtColor forState:UIControlStateNormal];
    btn.enabled = true;
    
    if (idx == 9) // Unlock button
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            btn.font = [UIFont boldSystemFontOfSize:15.0];
        }
        else
        {
            btn.font = [UIFont boldSystemFontOfSize:36.0];
        }
        [btn setBackgroundImage:[UIImage imageNamed:@"Unlock.png"] forState:UIControlStateNormal];
    }
}

- (int)indexOfSelectedBG
{
    int idx=0;
    NSString* bgname = (NSString*)[defaults objectForKey:@"background"];
    if ([bgname isEqualToString:@"Throne.jpg"])
    {
        idx = 1;
    }
    if ([bgname isEqualToString:@"HouseOfCards.jpg"])
    {
        idx = 2;
    }
    if ([bgname isEqualToString:@"MagicGrass.jpg"])
    {
        idx = 3;
    }
    if ([bgname isEqualToString:@"TasteOfPower.jpg"])
    {
        idx = 4;
    }
    if ([bgname isEqualToString:@"LostCity.jpg"])
    {
        idx = 5;
    }
    return idx;
}

- (int)indexOfSelectedTrack
{
    int idx=6;
    NSString* songname = (NSString*)[defaults objectForKey:@"track"];
    if ([songname isEqualToString:@"TheFuture"])
    {
        idx = 7;
    }
    if ([songname isEqualToString:@"BaySide"])
    {
        idx = 8;
    }
    return idx;
}

- (IBAction)enableButton_pressed:(id)sender {
    UIButton* pressedButton = (UIButton*)sender;
    int tag = pressedButton.tag;
    
    if (tag == 500)
    {
        [defaults setObject:@"null" forKey:@"background"];
    }
    if (tag == 501)
    {
        [defaults setObject:@"Throne.jpg" forKey:@"background"];
    }
    if (tag == 502)
    {
        [defaults setObject:@"HouseOfCards.jpg" forKey:@"background"];
    }
    if (tag == 503)
    {
        [defaults setObject:@"MagicGrass.jpg" forKey:@"background"];
    }
    if (tag == 504)
    {
        [defaults setObject:@"TasteOfPower.jpg" forKey:@"background"];
    }
    if (tag == 505)
    {
        [defaults setObject:@"LostCity.jpg" forKey:@"background"];
    }
    if (tag == 506)
    {
        [defaults setObject:@"Techno" forKey:@"track"];
    }
    if (tag == 507)
    {
        [defaults setObject:@"TheFuture" forKey:@"track"];
    }
    if (tag == 508)
    {
        [defaults setObject:@"BaySide" forKey:@"track"];
    }
    if (tag == 509)
    {
        [defaults setBool:true forKey:@"charm-powerup"];
        [pressedButton setBackgroundImage:nil forState:UIControlStateNormal];
        [pressedButton setTitleColor:unenabledTextColor forState:UIControlStateNormal];
        [pressedButton setBackgroundColor:unenabledColor];
        [pressedButton setFont:unenabledFont];
    }
    
    if (tag == 500 || tag == 501 || tag == 502 || tag == 503 || tag == 504 || tag == 505) // backgrounds
    {
        UIImageView* Img1 = (UIImageView*)checkImages[0];
        UIImageView* Img2 = (UIImageView*)checkImages[1];
        UIImageView* Img3 = (UIImageView*)checkImages[2];
        UIImageView* Img4 = (UIImageView*)checkImages[3];
        UIImageView* Img5 = (UIImageView*)checkImages[4];
        UIImageView* Img6 = (UIImageView*)checkImages[5];
        Img1.hidden = true;
        Img2.hidden = true;
        Img3.hidden = true;
        Img4.hidden = true;
        Img5.hidden = true;
        Img6.hidden = true;
    }
    if (tag == 506 || tag == 507 || tag == 508)
    {
        UIImageView* Img1 = (UIImageView*)checkImages[6];
        UIImageView* Img2 = (UIImageView*)checkImages[7];
        UIImageView* Img3 = (UIImageView*)checkImages[8];
        Img1.hidden = true;
        Img2.hidden = true;
        Img3.hidden = true;
    }
    
    int idx = [EnableButtons indexOfObject:pressedButton];
    UIImageView* Img = (UIImageView*)checkImages[idx];
    Img.hidden = false;
}

- (IBAction)infoButton_pressed:(id)sender {
    NSString* msgStr = @"";
    UIButton* btn = (UIButton*)sender;
    
    UIAlertView* av = [UIAlertView alloc];

    if (btn.tag == 600)
    {
        msgStr = @"To unlock this item, you need to invite at least one friend using the Invite Friends button. Note: You need to be logged into Game Center.";
    }
    if (btn.tag == 601)
    {
        msgStr = @"To unlock this item, you need to share your score on either Facebook or Twitter once. Note: You need to be logged into Game Center.";
    }
    if (btn.tag == 602)
    {
        msgStr = @"To unlock this item, you need to rate the app. Would you like to do so now? Note: You need to be logged into Game Center.";
        av.tag = 23940;
    }

    av = [av initWithTitle:@"Information"
                     message:msgStr
                    delegate:self
           cancelButtonTitle:@"Cancel"
           otherButtonTitles:@"OK", nil];
    [av show];
}

- (IBAction)backButton_pressed:(id)sender {
    if (sound_en)
        AudioServicesPlaySystemSound(ClickSoundID);
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 23940)
    {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/tap-titan-exciting-fast-paced/id904859657?ls=1&mt=8"]];
            if ([[GCHelper defaultHelper] reportAchievementIdentifier:@"TapTitan_ImSeeingStars" percentComplete:100.0])
            {
                [self addPoints:10];
                int taps = (int)[defaults integerForKey:@"credits"];
                int points = (int)[defaults integerForKey:@"points"];
                totalTaps.text = [NSString stringWithFormat:@"Taps: %d", taps];
                totalPoints.text = [NSString stringWithFormat:@"Points: %d", points];
                if ([[GCHelper defaultHelper] isAchievementComplete:@"TapTitan_ImSeeingStars"])
                {
                    if ([defaults boolForKey:@"charm-powerup"] == false)
                    {
                        [self enableButton:9];
                        UIButton* btn = infoButtons[2];
                        btn.hidden = true;
                    }
                }
                else
                {
                    UIButton* btn = infoButtons[2];
                    btn.hidden = false;
                }
            }
        }
    }
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
