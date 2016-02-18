//
//  PersistenceService.h
//  Ro Sham Know
//
//  Copyright © 2016 Conor Prischmann. All rights reserved.
//

#import <Foundation/Foundation.h>

// N.B.: This class can be called from either the iPhone app or the
// WatchKit Extension, but they're using separate standardUserDefaults stores.

@interface PersistenceService : NSObject

+ (nullable NSNumber *) storedHapticFeedbackValue;

+ (void) saveHapticSettingAsEnabled:(BOOL) enabled;

@end
