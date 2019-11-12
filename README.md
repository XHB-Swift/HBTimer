# HBTimer
基于GCD计时器封装的计时器类
## Usage
``` Objective-C
#import "HBTimer.h"
```
## Example
创建计时器对象
``` Objective-C
HBTimer *timer = [HBTimer timerWithTarget:self timeoutAction:@selector(timerDidTimeout)];
```
配置计时器参数
``` Objective-C
timer.start = 30; //启动时间
timer.duration = 3; //计时时间
timer.unit = HBTimeUnitMilliSecond; //计时单位
timer.accuracy = 3; //计时器精度
```
开启计时器
``` Objective-C
[timer startTimer];
```
超时回调
``` Objective-C
- (void)timerDidTimeout {

}
```
## Author
1021580211@qq.com
