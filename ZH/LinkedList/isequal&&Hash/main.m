//
//  main.m
//  isequal&&Hash
//
//  Created by 秦翌桐 on 2021/3/14.
//

#import <Foundation/Foundation.h>

#import "Person.h"

void change(int start, int index, NSMutableArray *array) {

    [array exchangeObjectAtIndex:start withObjectAtIndex:index];
    
}

void sort(int start, NSMutableArray *array) {
    
    if (start == array.count - 1) {
        NSLog(@"%@", array);
    }
    
    for (int i = start; i< array.count; i++) {
        
        change(start, i, array);
        sort(start+1, array);
        change(start, i, array);
    }
}



int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSMutableArray *array = @[@"1", @"2",@"3"].mutableCopy;

        sort(0, array);
        
        
    }
    return 0;
}




