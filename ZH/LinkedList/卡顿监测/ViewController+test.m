//
//  ViewController+test.m
//  卡顿监测
//
//  Created by 赵贺 on 2021/5/13.
//

#import "ViewController+test.h"
#import <objc/runtime.h>
@implementation ViewController (test)


- (void)setName:(NSString *)name {
    objc_setAssociatedObject(self, _cmd, name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)name {
    return objc_getAssociatedObject(self, _cmd);
}



@end
