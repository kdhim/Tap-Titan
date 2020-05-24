//
//  SettingsViewController.h
//  Tap Titan
//
//  Created by kevin dhimitri on 8/6/14.
//  Copyright (c) 2014 kevin dhimitri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface SettingsViewController : UIViewController
{
    IBOutlet UISwitch *musicSwitch;
    IBOutlet UISwitch *soundSwitch;
    IBOutlet UIButton *musicSwitchPad;
    IBOutlet UIButton *soundSwitchPad;
    
    NSUserDefaults* defaults;
    bool _music;
    bool _sound;
}

@end
