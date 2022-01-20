//
//  ViewController.m
//  copy&&mutableCopy
//
//  Created by 赵贺 on 2021/5/20.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, copy) NSString *str;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//https://blog.csdn.net/same_life/article/details/105676774
    
    NSMutableArray *arr = @[@1,@2].mutableCopy;
    
    NSMutableArray *arr1 = [NSMutableArray array];
    arr1 = arr;
    
    NSMutableArray *arr2 = [NSMutableArray array];
    arr2 = [arr mutableCopy];
    
    NSArray *arr3 = arr;
    
    NSArray *arr4 = [arr copy];
    
    NSArray *arr5 = [arr mutableCopy];
    
    
    [arr1 addObject:@3];
    
//    NSLog(@"arr = %@ %p , arr1 = %@  %p, arr2 = %@ %p, arr3 = %@  %p,arr4 = %@  %p,arr5 = %@  %p", arr,arr, arr1,arr1, arr2,arr2, arr3, arr3, arr4, arr4,arr5, arr5);
    
    
//    NSArray *arr6 = @[@1,@2];
//
//    NSArray *arr7 = arr6.copy;
//
//    NSArray *arr8 = arr6.mutableCopy;
//
//    NSLog(@"arr6 = %@, %p \n, arr7 = %@, %p, arr8 = %@, %p", arr6, arr6, arr7, arr7, arr8, arr8);
    
    NSString *str = @"lilei";
    
    NSString *strds = [NSString stringWithFormat:@"111"];
    
//    NSMutableString *str = [[NSMutableString alloc] initWithString:@"lilei"];
    
    NSString *str1 = str;
    NSString *str2 = [str copy];
    NSString *str3 = [str mutableCopy];
    
//    NSArray * str = @[@1];
//    NSArray *str1 = str;
//    NSArray *str2 = [str copy];
//    NSArray *str3 = [str mutableCopy];

    NSLog(@"%@ - %p - %p", str, str, &str);
    NSLog(@"%@ - %p - %p", str1, str1, &str1);
    NSLog(@"%@ - %p - %p", str2, str2, &str2);
    NSLog(@"%@ - %p - %p", str3, str3, &str3);
    str = @"hanmeimei";
//    str = @[@2];

    NSLog(@"%@ - %p - %p", str, str, &str);
    NSLog(@"%@ - %p - %p", str1, str1, &str1);
    NSLog(@"%@ - %p - %p", str2, str2, &str2);
    NSLog(@"%@ - %p - %p", str3, str3, &str3);
    
    
    
    
}


@end
