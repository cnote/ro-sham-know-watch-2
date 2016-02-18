//
//  ScoringContext.h
//  Ro Sham Know
//
//  Copyright (c) 2016 Conor Prischmann. All rights reserved.
//

@import Foundation;


@interface ScoringContext : NSObject

@property (nonatomic) BOOL isBestOfEnabled;
@property (nonatomic) BOOL needToWinByTwo;
@property (nonatomic) NSUInteger winningScore;

@end
