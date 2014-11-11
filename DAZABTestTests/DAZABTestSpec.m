#import "DAZABTest.h"

#define EXP_SHORTHAND 1;
#import <UIKit/UIKit.h>
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import "DAZMathHelper.h"

static const CGFloat DAZABTestSpecTValue = 3.1; // Assuming a t-distrubtion, error < 0.1% for large n.

SpecBegin(DAZABTest)

describe(@"splitTestWithName:conditions:", ^{

    beforeEach(^{
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
        CGFloat redConfidenceIntervalTolerance = [DAZMathHelper confidenceIntervalForBinomialDistributionWithTValue:DAZABTestSpecTValue
                                                                                                        probability:prRed
                                                                                                      numberOfTests:numberOfSplitTests];
        CGFloat redExpectedCount = prRed * numberOfSplitTests;
        expect([redArray count]).to.beInTheRangeOf(redExpectedCount - redConfidenceIntervalTolerance,
                                                   redExpectedCount + redConfidenceIntervalTolerance);

        CGFloat greenConfidenceIntervalTolerance = [DAZMathHelper confidenceIntervalForBinomialDistributionWithTValue:DAZABTestSpecTValue
                                                                                                        probability:prGreen
                                                                                                      numberOfTests:numberOfSplitTests];
        CGFloat greenExpectedCount = prGreen * numberOfSplitTests;
        expect([greenArray count]).to.beInTheRangeOf(greenExpectedCount - greenConfidenceIntervalTolerance,
                                                     greenExpectedCount + greenConfidenceIntervalTolerance);

        CGFloat blueConfidenceIntervalTolerance = [DAZMathHelper confidenceIntervalForBinomialDistributionWithTValue:DAZABTestSpecTValue
                                                                                                        probability:prBlue
                                                                                                      numberOfTests:numberOfSplitTests];
        CGFloat blueExpectedCount = prBlue * numberOfSplitTests;
        expect([blueArray count]).to.beInTheRangeOf(blueExpectedCount - blueConfidenceIntervalTolerance,
                                                    blueExpectedCount + blueConfidenceIntervalTolerance);
    });

    it(@"should persist result after the first test", ^{
        NSString *black = @"Black";
        CGFloat prBlack = 0.50;
        NSString *white = @"White";
        CGFloat prWhite = 0.50;
        NSDictionary *conditions = @{black : @(prBlack),
                                     white : @(prWhite)};
        NSString *testName = @"Test";
        NSString *color = [DAZABTest splitTestWithName:testName conditions:conditions];

        NSUInteger numberOfTests = 100;
        for (NSUInteger i = 0; i < numberOfTests; i++) {
            NSString *newColor = [DAZABTest splitTestWithName:testName conditions:conditions];
            expect(newColor).to.equal(color);
        }
    });
});

describe(@"splitTestWithName:values:", ^{

    beforeEach(^{
        NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
        for (NSString *key in [defaultsDictionary allKeys]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        }
    });

    it(@"should return each value with equal probablility", ^{
        NSString *red = @"Red";
        NSString *green = @"Green";
        NSString *blue = @"Blue";
        NSArray *values = @[red, green, blue];

        NSUInteger numberOfSplitTests = 1000;
        NSMutableArray *redArray = [[NSMutableArray alloc] init];
        NSMutableArray *greenArray = [[NSMutableArray alloc] init];
        NSMutableArray *blueArray = [[NSMutableArray alloc] init];
        for (NSUInteger i = 0; i < numberOfSplitTests; i++) {
            NSString *testName = [@"Test" stringByAppendingString:[@(i) stringValue]];
            NSString *color = [DAZABTest splitTestWithName:testName values:values];
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

        CGFloat prColor = (1.0 / 3.0);
        CGFloat colorConfidenceIntervalTolerance = [DAZMathHelper confidenceIntervalForBinomialDistributionWithTValue:DAZABTestSpecTValue
                                                                                                          probability:prColor
                                                                                                        numberOfTests:numberOfSplitTests];
        CGFloat colorExpectedCount = prColor * numberOfSplitTests;
        CGFloat rangeLowerBound = colorExpectedCount - colorConfidenceIntervalTolerance;
        CGFloat rangeUpperBound = colorExpectedCount + colorConfidenceIntervalTolerance;
        expect([redArray count]).to.beInTheRangeOf(rangeLowerBound, rangeUpperBound);
        expect([greenArray count]).to.beInTheRangeOf(rangeLowerBound, rangeUpperBound);
        expect([blueArray count]).to.beInTheRangeOf(rangeLowerBound, rangeUpperBound);
    });
});

describe(@"resetSplitTestWithName:", ^{

    beforeEach(^{
        NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
        for (NSString *key in [defaultsDictionary allKeys]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        }
    });

    it(@"should delete the value created by a previous split test, so a new value is generated the next time the split test runs", ^{
        NSUInteger numberOfValues = 1000000;
        NSMutableArray *valuesArray = [[NSMutableArray alloc] initWithCapacity:numberOfValues];
        for (NSUInteger i = 0; i < numberOfValues; i++) {
            [valuesArray addObject:@(i)];
        }
        NSString *testName = @"Test";
        NSNumber *firstValue = [DAZABTest splitTestWithName:testName values:valuesArray];
        [DAZABTest resetSplitTestWithName:testName];
        NSNumber *secondValue = [DAZABTest splitTestWithName:testName values:valuesArray];
        expect(firstValue).to.notTo.equal(secondValue);
    });
});

SpecEnd