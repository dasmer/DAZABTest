#import <Foundation/Foundation.h>

@interface DAZABTest : NSObject

/**
 Run a split test in which the user is randomly assigned to one of the specified values with equal probability.

 @param name A unique identifier for the test.
 @param values The possible results a user can be assigned to.

 @return The result of the split test with the given name.
 */
+ (id)splitTestWithName:(NSString *)name values:(NSArray *)values;

/**
 Run a split test in which the user is randomly assigned to one of the conditions with the specified probabilities.

 @param name A unique identifier for the test.
 @param conditions The keys are the possible results for the user to be assigned to and the values are the weighted probabilities of each result set as an `NSNumber`.

 @return The result of the split test with the given name.
 */
+ (id)splitTestWithName:(NSString *)name conditions:(NSDictionary *)conditions;

/**
 Reset a particular test, by clearing any previous assignments for the user.

 @param name A unique identifier for the test.
 */
+ (void)resetSplitTestWithName:(NSString *)name;

@end