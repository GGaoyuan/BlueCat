//
//  Person.m
//  Test_interview
//
//  Created by 秦翌桐 on 2021/3/14.
//

#import "Person.h"


@interface Person ()<NSCopying>

@property (nonatomic, copy, readwrite ) NSString *name;

@end

@implementation Person

static Person *p = nil;
static dispatch_once_t once;


+ (instancetype)instance {
    
    dispatch_once(&once, ^{
        p = [Person new];
    });
    
    return p;
}

+ (void)des {
    once = 0;
//    p = nil;
    
}

+(instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        p = [super allocWithZone:zone];
    });
    
    return p;
}

- (id)copyWithZone:(NSZone *)zone {
    return p;
}


- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
    }
    return self;
}

//
//- (BOOL)isEqual:(Person *)object {
//
//    return [object.name isEqualToString:self.name];
//
//}
//
//- (NSUInteger)hash {
//    return [self.name hash];
//
////    NSUInteger hash = [super hash];
////    NSLog(@"hash = %ld", hash);
////    return hash;
//
//}

- (void)dealloc {

    NSLog(@"%s", __func__);

}
@end
