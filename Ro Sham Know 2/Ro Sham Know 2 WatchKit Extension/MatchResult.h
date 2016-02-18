//
//  MatchResult.h
//  Ro Sham Know
//
//  Copyright (c) 2016 Conor Prischmann. All rights reserved.
//

@import Foundation;


@interface MatchResult : NSObject

@property (nonatomic) NSUInteger leftScore;
@property (nonatomic) NSUInteger rightScore;
@property (strong, nonatomic) NSDate *when;

@end
