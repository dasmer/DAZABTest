#import "DAZMathHelper.h"

@implementation DAZMathHelper

+ (CGFloat)confidenceIntervalForBinomialDistributionWithTValue:(CGFloat)tValue
                                                   probability:(CGFloat)probability
                                                 numberOfTests:(NSUInteger)numberOfTests
{
    return tValue * sqrt(numberOfTests * probability * (1 - probability)); // t*sqrt(n*p*(1-p))
}

@end
