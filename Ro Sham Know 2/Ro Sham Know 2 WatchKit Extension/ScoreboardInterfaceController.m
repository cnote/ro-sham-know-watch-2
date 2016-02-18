//
//  ScoreboardInterfaceController.m
//  Ro Sham Know
//
//  Copyright (c) 2016 Conor Prischmann. All rights reserved.
//

#import "ScoreboardInterfaceController.h"

#import "MatchResult.h"


@interface ScoreboardInterfaceController ()

@property (strong, nonatomic) MatchResult *matchResult;

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *scoreLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *resultLabel;

- (IBAction) newGameButtonPressed;

@end


@implementation ScoreboardInterfaceController

- (void) awakeWithContext:(id) context
{
    [super awakeWithContext:context];

    // This hides the "Cancel" button, though it's still enabled
    [self setTitle:@""];

    NSString *const leftText = @"Left";
    NSString *const rightText = @"Right";

    self.matchResult = (MatchResult *) context;
    NSString *winner = (self.matchResult.leftScore > self.matchResult.rightScore) ? leftText : rightText;
    NSString *loser = (self.matchResult.leftScore > self.matchResult.rightScore) ? rightText : leftText;

    self.resultLabel.text = [NSString stringWithFormat:@"%@ beat %@!", winner, loser];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %@ to %@", @(MAX(self.matchResult.leftScore, self.matchResult.rightScore)), @(MIN(self.matchResult.leftScore, self.matchResult.rightScore))];
}

- (IBAction) newGameButtonPressed
{
    [self dismissController];
}

@end
