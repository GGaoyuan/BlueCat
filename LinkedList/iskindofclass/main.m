//
//  main.m
//  iskindofclass
//
//  Created by 赵贺 on 2021/4/13.
//

#import <Foundation/Foundation.h>

#import "Person.h"
#import <objc/runtime.h>
#import <malloc/malloc.h>

extern void _objc_autoreleasePoolPrint(void);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
    
        
//        BOOL a = [[NSObject new] isKindOfClass:[NSObject class]];//1
//        BOOL b = [[NSObject new] isMemberOfClass:[NSObject class]];//1
//        BOOL c = [[Person new] isKindOfClass:[NSObject class]];//1
//        BOOL d = [[Person new] isMemberOfClass:[NSObject class]];//0
//        BOOL e = [[Person new] isKindOfClass:[Person class]];//1
//        BOOL f = [[Person new] isMemberOfClass:[Person class]];//1
        
        
//        BOOL a = [[NSObject class] isKindOfClass:[NSObject class]];//1
//        BOOL b = [[NSObject class] isMemberOfClass:[NSObject class]];//0
//        BOOL c = [[Person class] isKindOfClass:[NSObject class]];//1
//        BOOL d = [[Person class] isMemberOfClass:[NSObject class]];//0
//        BOOL e = [[Person class] isKindOfClass:[Person class]];//0
//        BOOL f = [[Person class] isMemberOfClass:[Person class]];//0
        
        
//        NSLog(@"%d  %d  %d   %d  %d  %d", a, b, c, d, e, f);

        
//        int a = 10;
//        NSInteger b = 10;
//
//        NSLog(@"%lu", sizeof(a));
//
//        NSLog(@"%lu", class_getInstanceSize([@(b) class]));
//
//        NSLog(@"%lu", sizeof(b));
//
//        NSLog(@"%lu", sizeof([NSObject new]));
        
        
        @autoreleasepool {
            
            _objc_autoreleasePoolPrint();
        }
        
    }
    return 0;
}
