//
//  ViewController.m
//  HBTimer
//
//  Created by 谢鸿标 on 2019/11/11.
//  Copyright © 2019 谢鸿标. All rights reserved.
//

#import "ViewController.h"
#import "Sources/HBTimer.h"

@interface ViewController ()

@property (nonatomic, strong) HBTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.timer = [HBTimer timerWithTarget:self timeoutAction:@selector(timerDidTimeout)];
    self.timer.duration = 3;
    self.timer.unit = HBTimeUnitMilliSecond;
    [self.timer startTimer];
}

- (void)timerDidTimeout {
    
    NSLog(@"%s", __func__);
}

@end
