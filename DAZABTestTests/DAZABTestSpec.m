#import "DAZABTest.h"

#define EXP_SHORTHAND 1;
#import <UIKit/UIKit.h>
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>

SpecBegin(DAZABTest)

describe(@"splitTestWithName:conditions:", ^{

    beforeAll(^{
        NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
        for (NSString *key in [defaultsDictionary allKeys]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        }
    });

    it(@"should return a key in conditions dictionary, at the probability determined by its corresponding value pair.", ^{
        NSString *red = @"Red";
        CGFloat prRed = 0.30;
        NSString *green = @"Green";
        CGFloat prGreen = 0.60;
        NSString *blue = @"Blue";
        CGFloat prBlue = 0.10;
        NSDictionary *conditions = @{red : @(prRed),
                                     green : @(prGreen),
                                     blue : @(prBlue)};

        NSUInteger numberOfSplitTests = 1000;
        NSMutableArray *redArray = [[NSMutableArray alloc] init];
        NSMutableArray *greenArray = [[NSMutableArray alloc] init];
        NSMutableArray *blueArray = [[NSMutableArray alloc] init];
        for (NSUInteger i = 0; i < numberOfSplitTests; i++) {
            NSString *testName = [@"Test" stringByAppendingString:[@(i) stringValue]];
            NSString *color = [DAZABTest splitTestWithName:testName conditions:conditions];
            if ([color isEqual:red]) {
                [redArray addObject:testName];
            }
            else if ([color isEqualToString:green]) {
                [greenArray addObject:testName];
            }
            else if ([color isEqualToString:blue]) {
                [blueArray addObject:testName];
            }
        }
        CGFloat confidenceIntervalTolerance = (1 - 0.95) * numberOfSplitTests;

        CGFloat expectedRedCount = prRed * numberOfSplitTests;
        expect([redArray count]).to.beInTheRangeOf(expectedRedCount - confidenceIntervalTolerance,
                                                   expectedRedCount + confidenceIntervalTolerance);

        CGFloat expectedGreenCount = prGreen * numberOfSplitTests;
        expect([greenArray count]).to.beInTheRangeOf(expectedGreenCount - confidenceIntervalTolerance,
                                                     expectedGreenCount + confidenceIntervalTolerance);

        CGFloat expectedBlueCount = prBlue * numberOfSplitTests;
        expect([blueArray count]).to.beInTheRangeOf(expectedBlueCount - confidenceIntervalTolerance,
                                                    expectedBlueCount + confidenceIntervalTolerance);
    });

});

SpecEnd