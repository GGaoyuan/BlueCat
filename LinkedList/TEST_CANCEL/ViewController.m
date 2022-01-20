//
//  ViewController.m
//  TEST_CANCEL
//
//  Created by 赵贺 on 2021/5/24.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, assign) BOOL isLiving;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UILabel * label;


@end

@implementation ViewController


//- (void)loadView {
//    self.label = [[UILabel alloc] init];
//    [self.view addSubview:self.label];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.isLiving = YES;
//
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        while (self.isLiving) {
//            [self performSelector:@selector(test1) withObject:nil afterDelay:5];
//            [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
//            [[NSRunLoop currentRunLoop] run];
//        }
//    });
//
//
//
////    dispatch_async(dispatch_get_global_queue(0, 0), ^{
////        NSTimer *timer = [NSTimer timerWithTimeInterval:3 repeats:YES block:^(NSTimer * _Nonnull timer) {
////             [self test1];
////             [self test2];
////         }];
////         self.timer = timer;
////         [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
////         [[NSRunLoop currentRunLoop] run];
////    });
//
//
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelsss)];
//    [self.view addGestureRecognizer:tap];
    
//
//    UILabel *label = [UILabel new];
//    self.label = label;
////
////    self.label = [UILabel new];
//
//    [self.view addSubview:self.label];
//
//    self.label.frame = CGRectMake(100, 100, 100, 100);
//    self.label.font = [UIFont systemFontOfSize:20];
//    self.label.text = @"我是label";
//    self.label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
//
//    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:@"内容g"];
//
//    [attribtStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(1, 2)];
//
//    label.attributedText = attribtStr;
    
    UIButton *butn=[[UIButton alloc]initWithFrame:CGRectMake(100, 100, 200, 30)];
    [butn setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.3]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"我是Buttongssss"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [butn setAttributedTitle:str forState:UIControlStateNormal];//这个状态要加上

    [butn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [butn setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    
    [self.view addSubview:butn];
    
}

- (void)cancelsss {
    
}


- (void)test1 {
    NSLog(@"--- 11");
}

- (void)test2 {
    NSLog(@"--- 22");
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    
        self.isLiving = !self.isLiving;
    NSLog(@"touch");
    
//    [self.timer invalidate];
    
}



@end
