//
//  HBTimer.h
//  HBTimer
//
//  Created by 谢鸿标 on 2019/11/11.
//  Copyright © 2019 谢鸿标. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HBTimeUnit) {
    HBTimeUnitSecond = 1, //秒
    HBTimeUnitMilliSecond = NSEC_PER_USEC, //毫秒
    HBTimeUnitMicroSecond = NSEC_PER_MSEC, //微秒
    HBTimeUnitNanoSecond = NSEC_PER_SEC, //纳秒
};

NS_ASSUME_NONNULL_BEGIN

@interface HBTimer : NSObject

//设置计时器开始时间
@property (nonatomic) dispatch_time_t start;

//设置计时时间
@property (nonatomic) NSTimeInterval duration;

//时间单位
@property (nonatomic) HBTimeUnit unit;

//设置计时器精度，默认：0
@property (nonatomic) NSUInteger accuracy;

/// 初始化计时器
/// @param target 超时执行的代理对象
/// @param action 超时触发的回调
+ (instancetype)timerWithTarget:(id)target timeoutAction:(SEL)action;

+ (instancetype)timerWithTarget:(id)target timeoutAction:(SEL)action inQueue:(dispatch_queue_t _Nullable)queue;

- (void)startTimer;

- (void)stopTimer;

@end

NS_ASSUME_NONNULL_END
