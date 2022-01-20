//
//  main.m
//  内存对齐
//
//  Created by 赵贺 on 2021/6/2.
//

#import <Foundation/Foundation.h>

#import <objc/runtime.h>
#import <malloc/malloc.h>

//1、定义两个结构体
struct Mystruct1{
    char a;     //1字节
    double b;   //8字节
    int c;      //4字节
    short d;    //2字节
}Mystruct1;

struct Mystruct2{
    double b;   //8字节
    int c;      //4字节
    short d;    //2字节
    char a;     //1字节
}Mystruct2;


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        //计算 结构体占用的内存大小
        NSLog(@"%lu-%lu",sizeof(Mystruct1),sizeof(Mystruct2));
        
        struct Mystruct1 struct1 = {'1',1.00,1,1};
        struct Mystruct2 struct2 = {2.00,1,1,'1'};
        
        NSLog(@"%lu-%lu",malloc_size((const void *)struct1),malloc_size((const void *)struct2);

    }
    return 0;
}
