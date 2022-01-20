//
//  main.m
//  Algorithm
//
//  Created by 赵贺 on 2021/4/15.
//

#import <Foundation/Foundation.h>

//冒泡
void bubbleSort() {
    
    NSMutableArray *arr = @[@11,@3,@1,@4,@5].mutableCopy;
    NSInteger length = arr.count;
    for (int i = 0; i < length - 1; i++) {
        for (int j = 0; j<length - 1 - i; j++) {
            if ([arr[j] intValue] > [arr[j+1] intValue]) {
                [arr exchangeObjectAtIndex:j+1 withObjectAtIndex:j];
            }
        }
    }
    NSLog(@"%@", arr);
}

//选择
void selectSort() {
    
    NSMutableArray *arr = @[@11,@3,@1,@4,@5, @1].mutableCopy;
    for (int i = 0; i < arr.count - 1; i++) {
        for (int j = i+1; j < arr.count; j++) {
            if ([arr[i] intValue] > [arr[j] intValue]) {
                [arr exchangeObjectAtIndex:i withObjectAtIndex:j];
                NSLog(@"%@", arr);
            }
        }
    }
}

//快排
void quickSort() {
    
    
    
    
}

// 全排列
void changeIndex(int start, int currentIndex, NSMutableArray *arr) {
    [arr exchangeObjectAtIndex:start withObjectAtIndex:currentIndex];
}

void sort(int start, NSMutableArray *arr) {
    
    if (start == arr.count - 1) {
        NSLog(@"%@", arr);
    }
    
    for (int i = start; i < arr.count; i++) {
        changeIndex(start, i, arr);
        sort(start+1, arr);
        changeIndex(start, i, arr);
    }
}

void allSort() {
    NSMutableArray *arr = @[@1,@2,@3].mutableCopy;
    sort(0, arr);
}


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
//        bubbleSort();
//        selectSort();
//        quickSort();
        allSort();
        [NSString new];
        [NSProxy new];
        [NSObject new];
    }
    return 0;
}
