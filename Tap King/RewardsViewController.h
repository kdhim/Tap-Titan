//
//  RewardsViewController.h
//  Tap Titan
//
//  Created by kevin dhimitri on 8/6/14.
//  Copyright (c) 2014 kevin dhimitri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "GCHelper.h"

#define MAX_POINTS 340

@interface RewardsViewController : UIViewController
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIButton *unlockedEnable;
    IBOutletCollection(UIButton) NSArray *infoButtons;
    IBOutlet UILabel *totalTaps;
    IBOutlet UILabel *totalPoints;
    IBOutlet UIImageView *unlockablesBG;
    IBOutletCollection(UIButton) NSArray *EnableButtons;
    IBOutletCollection(UIImageView) NSArray *checkImages;
    
    NSUserDefaults* defaults;
    UIColor* unenabledColor;
    UIColor* unenabledTextColor;
    UIFont* unenabledFont;
    UIColor* enabledColor;
    UIColor* enabledTxtColor;
    
    SystemSoundID ClickSoundID;
    bool sound_en;
}

@end
