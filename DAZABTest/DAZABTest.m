#import "DAZABTest.h"
#import <UIKit/UIKit.h>

static NSString *const DAZABTestUserDefaultsPrependKey = @"DAZABTestUserDefaultsPrependKey";
static dispatch_once_t srand48OnceToken;

@implementation DAZABTest

+ (id)splitTestWithName:(NSString *)name values:(NSArray *)values
{
    NSNumber *weight = @(1.0 / [values count]);
    NSMutableDictionary *conditions = [[NSMutableDictionary alloc] initWithCapacity:[values count]];
    for (id value in values) {
        conditions[value] = weight;
    }
    return [self splitTestWithName:name conditions:conditions];
}

+ (id)splitTestWithName:(NSString *)name conditions:(NSDictionary *)conditions
{
    NSString *userDefaultsKeyName = [self userDefaultsKeyForTestWithName:name];
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:userDefaultsKeyName];
    if (!value) {
        dispatch_once(&srand48OnceToken, ^{
            srand48(time(0));
        });
        NSArray *values = [conditions allKeys];
        NSArray *cumulativeWeights = [self cumulativeWeightsForValues:values inConditions:conditions];
        CGFloat sumOfWeights = [[cumulativeWeights lastObject] floatValue];
        CGFloat cumulativeProbability = drand48() * sumOfWeights;
        NSUInteger index = [self indexOfCumulativeProbability:cumulativeProbability
                                          inCumulativeWeights:cumulativeWeights];
        value = values[index];
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:userDefaultsKeyName];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return value;
    
}

+ (void)resetSplitTestWithName:(NSString *)name
{
    NSString *userDefaultsKeyName = [self userDefaultsKeyForTestWithName:name];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:userDefaultsKeyName];
}


#pragma mark - Private Helper Methods

+ (NSString *)userDefaultsKeyForTestWithName:(NSString *)testName
{
    return [DAZABTestUserDefaultsPrependKey stringByAppendingString:testName];
}

+ (NSArray *)cumulativeWeightsForValues:(NSArray *)values inConditions:(NSDictionary *)conditions
{
    CGFloat cumulativeWeight = 0;
    NSMutableArray *cumulativeWeights = [[NSMutableArray alloc] initWithCapacity:[values count]];
    for (id value in values) {
        CGFloat currentValueWeight = [conditions[value] floatValue];
        cumulativeWeight += currentValueWeight;
        [cumulativeWeights addObject:@(cumulativeWeight)];
    }
    return cumulativeWeights;
}

+ (NSUInteger)indexOfCumulativeProbability:(CGFloat)cumulativeProbability inCumulativeWeights:(NSArray *)cumulativeWeights
{
    NSUInteger index = ([cumulativeWeights count] - 1);
    for (NSUInteger i = 0; i < [cumulativeWeights count] - 1; i++) {
        if (cumulativeProbability < [cumulativeWeights[i] floatValue]) {
            index = i;
            break;
        }
    }
    return index;
}

@end
