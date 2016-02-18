//
//  ConfigurationInterfaceController.m
//  Ro Sham Know
//
//  Copyright (c) 2016 Conor Prischmann. All rights reserved.
//

#import "ConfigurationInterfaceController.h"

#import "ScoringContext.h"
#import "ScoringInterfaceController.h"


@interface ConfigurationInterfaceController ()

@property (strong, nonatomic) NSArray *winningScores;
@property (strong, nonatomic) ScoringContext *scoringContext;

@property (weak, nonatomic) IBOutlet WKInterfaceSlider *slider;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *bestOfButton;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *firstToButton;
@property (weak, nonatomic) IBOutlet WKInterfaceSwitch *winByTwoSwitch;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *startGameButton;
@property (weak, nonatomic) IBOutlet WKInterfacePicker *picker;

- (IBAction) bestOfButtonPressed;
- (IBAction) firstToButtonPressed;
- (IBAction) sliderAction:(float) value;
- (IBAction) startGameButtonPressed;
- (IBAction) winByTwoSwitchMoved:(BOOL) value;
- (IBAction) pickerDidChange:(NSInteger) value;

@end


@implementation ConfigurationInterfaceController

#pragma mark - Lifecycle

- (void) awakeWithContext:(id) context
{
    [super awakeWithContext:context];

    self.winningScores = @[@1, @2, @3, @5, @7, @9, @11, @15, @21, @25, @30, @55, @69, @77, @99];
    NSUInteger initialIndex = 4;
    NSUInteger initialWinningScore = [self.winningScores[initialIndex] integerValue];

    self.scoringContext = [[ScoringContext alloc] init];
    self.scoringContext.winningScore = initialWinningScore;

    [self.slider setValue:(float) initialIndex];

    [self.picker setItems:[self emptyPickerItemsWithCount:self.winningScores.count]];
    [self.picker setSelectedItemIndex:initialIndex];
    [self.picker focus];

    [self bestOfModeShouldBeOn:NO];
    [self refreshStartButtonName];
}

#pragma mark - Actions

- (IBAction) sliderAction:(float) value
{
    NSUInteger index = (int) value;

    self.scoringContext.winningScore = [self.winningScores[index] integerValue];
    [self.picker setSelectedItemIndex:index];
    [self refreshStartButtonName];
}

// Picker is not visible; it's only used to receive digital crown scrolling
- (IBAction) pickerDidChange:(NSInteger) value
{
    self.scoringContext.winningScore = [self.winningScores[value] integerValue];
    [self.slider setValue:(float) value];
    [self refreshStartButtonName];
}

- (IBAction) bestOfButtonPressed
{
    [self bestOfModeShouldBeOn:YES];
    [self refreshStartButtonName];
}

- (IBAction) firstToButtonPressed
{
    [self bestOfModeShouldBeOn:NO];
    [self refreshStartButtonName];
}

- (IBAction) winByTwoSwitchMoved:(BOOL) value
{
    self.scoringContext.needToWinByTwo = value;
}

- (IBAction) startGameButtonPressed
{
    [self pushControllerWithName:@"Scoring" context:self.scoringContext];
}

#pragma mark - Helpers

- (void) bestOfModeShouldBeOn:(BOOL) shouldBeOn
{
    self.scoringContext.isBestOfEnabled = shouldBeOn;

    [self.bestOfButton setBackgroundColor:(shouldBeOn ? [UIColor purpleColor] : [UIColor clearColor])];
    [self.firstToButton setBackgroundColor:(shouldBeOn ? [UIColor clearColor] : [UIColor purpleColor])];
}

- (void) refreshStartButtonName
{
    NSString *startGameButtonDescription = [NSString stringWithFormat:@"Start: %@ %@", (self.scoringContext.isBestOfEnabled ? @"Best Of" : @"First To"), @(self.scoringContext.winningScore)];

    [self.startGameButton setTitle:startGameButtonDescription];
}

- (NSArray<WKPickerItem *> *) emptyPickerItemsWithCount:(NSUInteger) count
{
    WKPickerItem *pickerItem = [[WKPickerItem alloc] init];

    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:count];

    for (NSUInteger i = 0; i < count; i++)
    {
        [array addObject:pickerItem];
    }

    return array;
}

@end
