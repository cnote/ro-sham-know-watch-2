//
//  SettingsService.m
//  Ro Sham Know
//
//  Copyright © 2016 Conor Prischmann. All rights reserved.
//

#import "SettingsService.h"

#import "PersistenceService.h"

@import WatchConnectivity;


@interface SettingsService () <WCSessionDelegate>

@property (nonatomic, readwrite) BOOL isHapticFeedbackEnabled;

@end


@implementation SettingsService

+ (instancetype) sharedInstance
{
    static SettingsService *sharedInstance;
    static dispatch_once_t dispatchToken;

    dispatch_once(&dispatchToken, ^{
        sharedInstance = [[SettingsService alloc] init];

        NSNumber *hapticSetting = [PersistenceService storedHapticFeedbackValue];
        sharedInstance.isHapticFeedbackEnabled = hapticSetting ? [hapticSetting boolValue] : kDefaultHapticFeedbackSetting;
    });

    return sharedInstance;
}

- (void) startSession
{
    if ([WCSession isSupported])
    {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
}

#pragma mark - WCSessionDelegate

- (void)      session:(WCSession *) session
    didReceiveMessage:(NSDictionary<NSString *, id> *) message
         replyHandler:(void (^)(NSDictionary<NSString *, id> *replyMessage)) replyHandler
{
    DLog(@"Received message: %@", message);
    NSNumber *hapticFeedbackValue = message[kConnectivityMessageKeyHapticFeedback];

    if (hapticFeedbackValue)
    {
        BOOL hapticSetting = [hapticFeedbackValue boolValue];
        self.isHapticFeedbackEnabled = hapticSetting;
        [PersistenceService saveHapticSettingAsEnabled:hapticSetting];
    }

    replyHandler(message);
}

@end
