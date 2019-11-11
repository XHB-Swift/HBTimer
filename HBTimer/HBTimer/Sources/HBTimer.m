//
//  HBTimer.m
//  HBTimer
//
//  Created by 谢鸿标 on 2019/11/11.
//  Copyright © 2019 谢鸿标. All rights reserved.
//

#import "HBTimer.h"

@interface HBTimer ()

@property (nonatomic, strong) NSMutableArray<dispatch_source_t> *timerPool;
@property (nonatomic, strong) NSMutableArray<dispatch_source_t> *timeoutTimerPool;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, weak) NSProcessInfo *processInfo;
@property (nonatomic, weak) id target;
@property (nonatomic) SEL action;
@property (nonatomic) NSTimeInterval beginTiming;

@end

@implementation HBTimer

+ (instancetype)timerWithTarget:(id)target timeoutAction:(SEL)action {
    return [[HBTimer alloc] initWithTarget:target timeoutAction:action];
}

- (instancetype)initWithTarget:(id)target timeoutAction:(SEL)action {
    return [self initWithTarget:target timeoutAction:action inQueue:NULL];
}

+ (instancetype)timerWithTarget:(id)target timeoutAction:(SEL)action inQueue:(dispatch_queue_t _Nullable)queue {
    return [[HBTimer alloc] initWithTarget:target timeoutAction:action inQueue:queue];
}

- (instancetype)initWithTarget:(id)target timeoutAction:(SEL)action inQueue:(dispatch_queue_t _Nullable)queue {
    
    if (self = [super init]) {
        _processInfo = [NSProcessInfo processInfo];
        _target = target;
        _action = action;
        _start = DISPATCH_TIME_NOW;
        _duration = 0;
        _unit = HBTimeUnitSecond;
        _accuracy = 0;
        _queue = queue ?: dispatch_queue_create("com.xhb.timer.queue", DISPATCH_QUEUE_SERIAL);
        _timerPool = [NSMutableArray array];
        _timeoutTimerPool = [NSMutableArray array];
    }
    return self;
}

- (instancetype)init {
    return nil;
}

- (uint64_t)timerInterval {
    uint64_t unit = NSEC_PER_SEC;
    switch (self.unit) {
        case HBTimeUnitMilliSecond:
            unit = NSEC_PER_USEC;
            break;
        case HBTimeUnitMicroSecond:
            unit = NSEC_PER_MSEC;
            break;
        case HBTimeUnitNanoSecond:
            unit = 1;
            break;
        default:
            break;
    }
    return self.duration * unit;
}

- (void)startTimer {
    @synchronized (self) {
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.queue);
        dispatch_source_set_timer(timer, self.start, [self timerInterval], self.accuracy);
        dispatch_source_set_event_handler(timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSTimeInterval delta = ([self.processInfo systemUptime] - self.beginTiming) * self.unit;
                if (delta >= self.duration) {
                    if (timer && ![self.timeoutTimerPool containsObject:timer]) {
                        [self.timeoutTimerPool addObject:timer];
                        [self stopTimer];
                        if (self.target && [self.target respondsToSelector:self.action]) {
                            IMP actionIMP = [self.target methodForSelector:self.action];
                            void(*actionFunc)(id, SEL, HBTimer *) = (void *)actionIMP;
                            actionFunc(self.target, self.action, self);
                        }
                    }
                }
            });
        });
        dispatch_resume(timer);
        self.beginTiming = [self.processInfo systemUptime];
        [self.timerPool addObject:timer];
    }
}

- (void)stopTimer {
    @synchronized (self) {
        dispatch_source_t timer = self.timerPool.firstObject;
        if (timer) {
            dispatch_source_cancel(timer);
            [self.timerPool removeObject:timer];
        }
    }
}

@end
