//
//  PersistenceService.m
//  Ro Sham Know
//
//  Copyright © 2016 Conor Prischmann. All rights reserved.
//

#import "PersistenceService.h"


@implementation PersistenceService

+ (nullable NSNumber *) storedHapticFeedbackValue
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    return [userDefaults objectForKey:kUserDefaultsKeyHapticFeedback];
}

+ (void) saveHapticSettingAsEnabled:(BOOL) enabled
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    [userDefaults setObject:@(enabled) forKey:kUserDefaultsKeyHapticFeedback];
    [userDefaults synchronize];
}

@end
