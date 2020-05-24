//
//  SecondViewController.h
//  Tap King
//
//  Created by kevin dhimitri on 7/13/14.
//  Copyright (c) 2014 kevin dhimitri. All rights reserved.
//

/*
    Achievements:
    - Get 3 crowns (done) Just A Prince - 5
    - Get 6 crowns (done) Fit For A King - 10
    - Get 9 crowns (done) King Of Crowns - 20
    - Pop 4 Balloons (done) Happy Birthday To You - 5
    - Get 5X multiplier (done) Full House - 30
    - Get 4X multiplier (done) Straight Kings - 20
    - Get 3X multiplier (done) Triple The Fun - 10
    - Get a crown while under the effects of a diamond (done) Magical Realism - 10
    - No power-ups appear during a game. (done) What Is Luck - 10
    - Tap all objects that appear in a game (done) Don't Get Caught Slipping - 10
    - Get 200 taps with no power-ups (done) Titan's Resilience - 10
    - Get a balloon, crown, and diamond in that order (done) One After Another - 20
    - Get a diamond within the last 3 seconds of the game. A Final Effort - 10
    - Get 3 diamonds (done) Dreams Do Come True - 20
    - Get 200 taps (done) Novice Tapper - 5
    - Get 300 taps (done) Intermediate Tapper - 10
    - Get 500 taps (done) Expert Tapper - 15
    - Get 650 taps (done) Master Tapper - 20
    - Get 900 taps (done) A Titan Has Been Born - 30
    - Share to Facebook (done) To My Facebook Friends - 20
    - Share to Twitter (done) To My Twitter Buds - 20
    - Invite someone to play (done) Now Its A Party - 10
    - Like us on Facebook (done) I Am A Like Titan - 10
    - Follow us on Twitter (done) Take Us To Your Leader - 10
    - Rate our app (done) Im Seeing Stars - 10
 
    Total: Ach's - 25, Points - 350
 */

/* TO DO:
    - Make game center not needed for game center points
    - Make power-ups not on rewards screen
 */

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <FacebookSDK/FacebookSDK.h>
#import <iAd/iAd.h>
#import "GCHelper.h"

#define MAX_POINTS 350
#define FONT_PRICEDOWN(s) [UIFont fontWithName:@"carbon" size:s]

@interface SecondViewController : UIViewController <ADBannerViewDelegate>
{
    int taps;
    int tap_multiplier;
    int secs;
    int secs_diamond;
    int secs_grail_gems;
    int start_tag;
    int start_tag_gr;
    int start_tag_gr_d;
    int start_tag_gr_d_btn;
    int grail_movements;
    int grail_gems;
    int max_grail_gems;
    
    // for achievements
    int balloon_count;
    int object_count;
    int balloon_obtained;
    int crown_obtained;
    int diamond_obtained;
    int object_obtained;
    int obj_cycle;
    
    bool is_sound_en;
    bool is_music_en;
    bool playing;
    bool inDiamond;
    bool text_moved;
    bool text_moved_10;
    bool text_moved_100;
    bool text_moved_1000;
    
    NSInteger theHS;
    NSTimer* _timer;
    NSTimer* crownSpawn_timer;
    NSTimer* grailSpawn_timer;
    NSTimer* grailGemSpawn_timer;
    NSTimer* crown_timer;
    NSTimer* bannerTimer;
    NSMutableArray* UnusedBalloonImgTags;
    NSMutableArray* UnusedDiamondObjects;
    NSMutableArray* DiamondTaps;
    NSUserDefaults* defaults;
    
    UIColor* defStaticTapsColor;
    UIColor* defMultiplyLabelColor;
    UIColor* defBackButtonColor;
    UIColor* defHighscoreLabelColor;
    UIImage* brokenDiamond;
    UIImage* diamondWorldImg;
    
    IBOutlet UILabel *timerText;
    IBOutlet UILabel *tapsText;
    IBOutlet UILabel *highscoreText;
    IBOutlet UIImageView *hiscoreImg;
    IBOutlet UIImageView *addedTimeImg;
    IBOutlet UIImageView *timesUpImg;
    IBOutlet ADBannerView *gameAD;
    IBOutlet UIImageView *screenPH;
    IBOutlet UIImageView *multiTapImg;
    IBOutlet UIButton *share1;
    IBOutlet UIButton *share2;
    IBOutlet UIButton *shareFB;
    IBOutlet UIButton *shareTWT;
    IBOutlet UILabel *staticTapsLabel;
    IBOutlet UILabel *multiplierLabel;
    IBOutlet UIButton *grailButton;
    IBOutlet UIButton *crownButton;
    IBOutlet UIButton *backButton;
    IBOutletCollection(UIImageView) NSArray *BalloonImages;
    IBOutletCollection(UIButton) NSArray *BalloonButtons;
    IBOutletCollection(UIImageView) NSArray *DiamondImages;
    IBOutletCollection(UIButton) NSArray *DiamondButtons;
    SystemSoundID ClickSoundID;
    SystemSoundID BalloonSoundID;
    SystemSoundID HighscoreSoundID;
    SystemSoundID DingSoundID;
    SystemSoundID UnlockedSoundID;
    SystemSoundID RockTapSoundID;
    SystemSoundID RockCrushSoundID;
    SystemSoundID GrailSoundID;
    SystemSoundID GrailGemSoundID;
    AVAudioPlayer* audioPlayer;
}

@end
