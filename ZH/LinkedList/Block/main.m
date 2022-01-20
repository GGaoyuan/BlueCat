//
//  main.m
//  Block
//
//  Created by 赵贺 on 2021/1/25.
//

#import <Foundation/Foundation.h>

int c = 10;

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        //1.未访问 auto 变量
        dispatch_block_t block = ^{
            NSLog(@"global block");
        };
        NSLog(@"%@", block);
        
        //2.访问 auto 变量 mrc 下 stackBlock  arc 下会调用 copy，拷贝到堆上， mallocBlock
        int a = 10;
        dispatch_block_t block1 = ^{
            NSLog(@"a = %d", a);
        };
        NSLog(@"%@", block1);
        
        //3.访问 static 变量， globalBlock
        static int b = 20;
        dispatch_block_t block2 = ^{
            NSLog(@"b = %d", b);
        };
        NSLog(@"%@", block2);
        
        //4.访问全局变量， globalBlock
        dispatch_block_t block3 = ^{
            NSLog(@"c = %d", c);
        };
        NSLog(@"%@", block3);
    }
    return 0;
}
