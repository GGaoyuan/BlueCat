//
//  ViewController.m
//  防止中间人攻击
//
//  Created by 赵贺 on 2021/5/23.
//

#import "ViewController.h"
#import "ProxyTest.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
}

- (void)becomeActive {
    
    
    BOOL isProxy = [ProxyTest getProxyStatus];
    
    NSLog(@"%d", isProxy);
    
}
@end
