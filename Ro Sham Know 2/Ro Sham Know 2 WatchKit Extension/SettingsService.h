//
//  SettingsService.h
//  Ro Sham Know
//
//  Copyright © 2016 Conor Prischmann. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SettingsService : NSObject

@property (nonatomic, readonly) BOOL isHapticFeedbackEnabled;

+ (instancetype) sharedInstance;

- (void) startSession;

@end
