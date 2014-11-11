#import <UIKit/UIKit.h>

@interface DAZMathHelper : NSObject

+ (CGFloat)confidenceIntervalForBinomialDistributionWithTValue:(CGFloat)tValue
                                                   probability:(CGFloat)probability
                                                 numberOfTests:(NSUInteger)numberOfTests;

@end
