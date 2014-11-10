#import <Foundation/Foundation.h>

@interface DAZABTest : NSObject

+ (id)splitTestWithName:(NSString *)name values:(NSArray *)values;

+ (id)splitTestWithName:(NSString *)name conditions:(NSDictionary *)conditions;

+ (void)resetSplitTestWithName:(NSString *)name;

@end
