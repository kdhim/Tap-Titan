//
//  SettingsViewController.m
//  Tap Titan
//
//  Created by kevin dhimitri on 8/6/14.
//  Copyright (c) 2014 kevin dhimitri. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

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
    
    defaults = [NSUserDefaults standardUserDefaults];
    _sound = [defaults boolForKey:@"sound"];
    _music = [defaults boolForKey:@"music"];
    
    [self.navigationController setNavigationBarHidden:NO];
    [musicSwitch setOn:_music];
    [soundSwitch setOn:_sound];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [musicSwitchPad setSelected:_music];
        [soundSwitchPad setSelected:_sound];
        [self updatePad];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [self.navigationController setNavigationBarHidden:YES];
    }
    [super viewWillDisappear:animated];
}

- (IBAction)resetButton_pressed:(id)sender {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Confirm Action"
                                                    message:@"Are you sure you want to reset your highscore?"
                                                   delegate:self
                                          cancelButtonTitle:@"Yes"
                                          otherButtonTitles:@"No", nil];
    [alert show];
}

- (void)updatePad
{
    if (_music)
    {
        [musicSwitchPad setImage:[UIImage imageNamed:@"switch_on.png"] forState:UIControlStateNormal];
    }
    else
    {
       [musicSwitchPad setImage:[UIImage imageNamed:@"switch_off.png"] forState:UIControlStateNormal];
    }
    
    if (_sound)
    {
        [soundSwitchPad setImage:[UIImage imageNamed:@"switch_on.png"] forState:UIControlStateNormal];
    }
    else
    {
        [soundSwitchPad setImage:[UIImage imageNamed:@"switch_off.png"] forState:UIControlStateNormal];
    }

}

- (IBAction)musicSlider_changed:(id)sender {
    _music = musicSwitch.on;
    [defaults setBool:_music forKey:@"music"];
    [defaults synchronize];
}

- (IBAction)soundSlider_changed:(id)sender {
    _sound = soundSwitch.on;
    [defaults setBool:_sound forKey:@"sound"];
    [defaults synchronize];
}

- (IBAction)musicSwitchPad:(id)sender {
    musicSwitchPad.selected = !musicSwitchPad.selected;
    _music = musicSwitchPad.selected;
    [defaults setBool:_music forKey:@"music"];
    [defaults synchronize];
    [self updatePad];
}

- (IBAction)soundSwitchPad:(id)sender {
    soundSwitchPad.selected = !soundSwitchPad.selected;
    _sound = soundSwitchPad.selected;
    [defaults setBool:_sound forKey:@"sound"];
    [defaults synchronize];
    [self updatePad];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [defaults setInteger:0 forKey:@"highscore"];
        [defaults synchronize];
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
