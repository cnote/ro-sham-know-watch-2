//
//  MainViewController.m
//  Ro Sham Know
//
//  Copyright © 2016 Conor Prischmann. All rights reserved.
//

#import "MainViewController.h"

#import "PersistenceService.h"

@import WatchConnectivity;


@interface MainViewController () <WCSessionDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *hapticFeedbackSwitch;

- (IBAction) hapticFeedbackSwitchDidChange:(UISwitch *) sender;

@end


@implementation MainViewController

- (void) viewDidLoad
{
    [super viewDidLoad];

    // Wait until we determine the watch reachability status before letting the user change the haptic setting
    [self configureSwitchAsEnabled:NO];

    NSNumber *hapticSetting = [PersistenceService storedHapticFeedbackValue];
    self.hapticFeedbackSwitch.on = hapticSetting ? [hapticSetting boolValue] : kDefaultHapticFeedbackSetting;

    if ([WCSession isSupported])
    {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
        [self configureSwitchAsEnabled:session.reachable];
    }
}

- (void) configureSwitchAsEnabled:(BOOL) enabled
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hapticFeedbackSwitch.userInteractionEnabled = enabled;
        self.hapticFeedbackSwitch.alpha = enabled ? 1.0 : 0.25;
    });
}

#pragma mark - WCSessionDelegate

- (void) sessionReachabilityDidChange:(WCSession *) session
{
    DLog(@"Watch reachability status: %@", @(session.reachable));
    [self configureSwitchAsEnabled:session.reachable];
}

#pragma mark - Actions

- (IBAction) hapticFeedbackSwitchDidChange:(UISwitch *) sender
{
    // Disable the switch until we hear back from the watch
    [self configureSwitchAsEnabled:NO];

    BOOL isHapticFeedbackEnabled = sender.on;

    // Make sure watch is still reachable; if not, reverse switch action
    if (![WCSession defaultSession].reachable)
    {
        DLog(@"Watch is no longer reachable!");
        sender.on = !isHapticFeedbackEnabled;
        return;
    }

    // Tell the watch what happened
    [[WCSession defaultSession] sendMessage:@{ kConnectivityMessageKeyHapticFeedback : @(isHapticFeedbackEnabled) } replyHandler:^(NSDictionary *replyMessage) {
         [PersistenceService saveHapticSettingAsEnabled:isHapticFeedbackEnabled];
         // The watch got our message, so re-enable the switch, if the watch is still reachable
         [self configureSwitchAsEnabled:[WCSession defaultSession].reachable];
     } errorHandler:^(NSError *error) {
         DLog(@"Error: %@", error);
         // Assume watch didn't get the message, so reverse course
         dispatch_async(dispatch_get_main_queue(), ^{
            sender.on = !isHapticFeedbackEnabled;
         });
         [self configureSwitchAsEnabled:[WCSession defaultSession].reachable]; //Reenable switch
     }];
}

@end
