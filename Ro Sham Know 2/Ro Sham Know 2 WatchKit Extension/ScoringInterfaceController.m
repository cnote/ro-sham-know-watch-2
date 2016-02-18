//
//  ScoringInterfaceController.m
//  Ro Sham Know
//
//  Copyright (c) 2016 Conor Prischmann. All rights reserved.
//

#import "ScoringInterfaceController.h"

#import "MatchResult.h"
#import "ScoringContext.h"
#import "SettingsService.h"

typedef NS_ENUM (NSInteger, ScorePress)
{
    ScorePressLeft = -1,
    ScorePressRight = 1
};


@interface ScoringInterfaceController ()

@property (nonatomic) NSUInteger leftCount;
@property (nonatomic) NSUInteger rightCount;
@property (strong, nonatomic) NSMutableArray *previousPresses; //<NSNumber-wrapped ScorePress *>
@property (strong, nonatomic) ScoringContext *scoringContext;

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *leftScore;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *rightScore;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *undoButton;

- (IBAction) undoPressed;
- (IBAction) leftPressed;
- (IBAction) rightPressed;

@end


@implementation ScoringInterfaceController

#pragma mark - Lifecycle

- (void) awakeWithContext:(id) context
{
    [super awakeWithContext:context];

    self.previousPresses = [NSMutableArray new];

    [self.undoButton setEnabled:NO];
    self.scoringContext = context;
}

#pragma mark - Button Handling

- (IBAction) undoPressed
{
    if ([SettingsService sharedInstance].isHapticFeedbackEnabled)
    {
        [[WKInterfaceDevice currentDevice] playHaptic:WKHapticTypeRetry];
    }

    if (self.previousPresses.count > 0)
    {
        if ([[self.previousPresses lastObject] isEqualToNumber:@(ScorePressLeft)])
        {
            self.leftCount--;
            [self updateLeftDisplay];
        }
        else
        {
            self.rightCount--;
            [self updateRightDisplay];
        }

        [self.previousPresses removeLastObject];

        if (self.previousPresses.count < 1)
        {
            [self.undoButton setEnabled:NO];
        }
    }
}

- (IBAction) leftPressed
{
    self.leftCount++;
    [self updateLeftDisplay];
    [self.previousPresses addObject:@(ScorePressLeft)];
    [self.undoButton setEnabled:YES];
    [self checkForWinner];
}

- (IBAction) rightPressed
{
    self.rightCount++;
    [self updateRightDisplay];
    [self.previousPresses addObject:@(ScorePressRight)];
    [self.undoButton setEnabled:YES];
    [self checkForWinner];
}

- (void) updateLeftDisplay
{
    self.leftScore.text = [NSString stringWithFormat:@"%@", @(self.leftCount)];
}

- (void) updateRightDisplay
{
    self.rightScore.text = [NSString stringWithFormat:@"%@", @(self.rightCount)];
}

- (void) checkForWinner
{
    if (self.leftCount != self.rightCount)
    {
        if (self.scoringContext.isBestOfEnabled)
        {
            if (((self.leftCount + self.rightCount) >= self.scoringContext.winningScore) && [self twoPointDifferenceOrNotRequired])
            {
                [self someoneWon];
            }
        }
        else
        {
            if (((self.leftCount >= self.scoringContext.winningScore) || (self.rightCount >= self.scoringContext.winningScore)) &&
                [self twoPointDifferenceOrNotRequired])
            {
                [self someoneWon];
            }
        }
    }

    // Soft tap if this was a non-winning score
    if ([SettingsService sharedInstance].isHapticFeedbackEnabled)
    {
        [[WKInterfaceDevice currentDevice] playHaptic:WKHapticTypeClick];
    }
}

- (BOOL) twoPointDifferenceOrNotRequired
{
    return (!self.scoringContext.needToWinByTwo ||
            (self.scoringContext.needToWinByTwo && (abs((int) self.leftCount - (int) self.rightCount) >= 2)));
}

- (void) someoneWon
{
    if ([SettingsService sharedInstance].isHapticFeedbackEnabled)
    {
        [[WKInterfaceDevice currentDevice] playHaptic:WKHapticTypeSuccess];
    }

    MatchResult *matchResult = [[MatchResult alloc] init];

    matchResult.leftScore = self.leftCount;
    matchResult.rightScore = self.rightCount;
    matchResult.when = [NSDate date];

    [self presentControllerWithName:@"Scoreboard" context:matchResult];
    [self popToRootController];
}

@end
