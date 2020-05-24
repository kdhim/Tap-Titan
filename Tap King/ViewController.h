//
//  ViewController.h
//  Tap King
//
//  Created by kevin dhimitri on 7/10/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <FacebookSDK/FacebookSDK.h>
#import <QuartzCore/QuartzCore.h>
#import <iAd/iAd.h>
#import "GCHelper.h"

#define ResetHSAlert 81
#define MAX_POINTS 350

@interface ViewController : UIViewController <ADBannerViewDelegate>
{
    bool sound_en;
    int start_tag;
    
    NSUserDefaults* defaults;
    NSTimer* bannerTimer;
    NSString* currentLeaderBoard;
    SystemSoundID ClickSoundID;
    
    UIImage* thepic;
    UIImageView* music_img;
    UIImageView* sound_img;
    
    IBOutlet UIImageView *backgroundDef;
    IBOutlet UILabel *socialLabel;
}

@end
