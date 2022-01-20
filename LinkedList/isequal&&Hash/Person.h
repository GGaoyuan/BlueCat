//
//  Person.h
//  isequal&&Hash
//
//  Created by 秦翌桐 on 2021/3/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property (nonatomic, copy , readonly) NSString *name;

@property (nonatomic, assign) int age;

- (instancetype)initWithName:(NSString *)name;

+ (void)des;
+ (instancetype)instance;
@end

NS_ASSUME_NONNULL_END
