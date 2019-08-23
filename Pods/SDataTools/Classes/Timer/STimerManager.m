//
//  STimerManager.m
//  SMultithreadingBlockTest
//
//  Created by SSS on 2019/8/20.
//  Copyright © 2019 SSS. All rights reserved.
//

#import "STimerManager.h"
#import "SDataTools.h"
#import "math.h"

//#define TIMEINTERVAL 1

#define DISPATCH_QUEUE_TIME @"com.sss.stimer"
#define QUEUE_TIME self.queue
#define QUEUE_ASYNC_TIME(block) dispatch_async(QUEUE_TIME, ^{block})

@interface STimerManager()
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)long long time;
@property(nonatomic,assign)uint timeInterval;
@property (strong, nonatomic, nullable) dispatch_queue_t queue;
@property(nonatomic,assign)bool isLog;
@end

@implementation STimerManager
#pragma mark 单例初始化
+ (instancetype)sharedInstance
{
    static STimerManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setTimeInterval:1];
    }
    return self;
}

-(void)startWithLog:(bool)islog{
    [self setIsLog:islog];
    [self start];
}

-(void)start{
    self.timer=[NSTimer timerWithTimeInterval:self.timeInterval target:self selector:@selector(timeUpdate) userInfo:nil repeats:true];
    //QUEUE_ASYNC_HIGH()
    //开启计时器
//     [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    //不能使用mainloop,子线程才能不受其他线程sleep受影响
   self.queue= dispatch_queue_create("com.hackemist.SDWebImageCache", DISPATCH_QUEUE_SERIAL);
    QUEUE_ASYNC_TIME(
                      [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                     );
    
   
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), self.queue, ^{
//
//    });
//    QUEUE_ASYNC_DEFAULT(
//                  [self disturb];
//    );
}
//-(void)disturb{
//    sleep(2);
//    OCLOGD(@"sleep end");
//}


#pragma mark 内部函数

-(void)timeUpdate{
//    OCLOGD(@"sleep start");
//    sleep(2);
//    OCLOGD(@"sleep end");
//    sleep(2);
//    OCLOGD(@"sleep end2");
    //达到最大值之前重置
    if (self.time>=LONG_LONG_MAX-self.timeInterval) {
        self.time=0;
    }
    [self setTime:self.time+1];
    if (self.isLog) {
         NSLog(@"STimerManager::%lld",self.time);
    }
   
   [[NSNotificationCenter defaultCenter] postNotificationName: TIME_UPDATE_NOTICE object: @(self.time)];
    
//    self.progressPercent+=ADD_SIGNPERCENT_PERTIME;
//    OCLOGD(@"packProgressUpdate--%d::time::%@",self.progressPercent,[STimeTool getNowTime:nil]);
//    long long msgId=[[IMSDKCenter sharedInstance]allocMsgID:0];
//    //上报打包进度
//    [[IMSDKCenter sharedInstance]sendPackMsgWhenSigning:msgId withProgress:self.progressPercent];
//    if (self.progressPercent>FINISH_PERCENT) {
//
//        //销毁定时器
//        [self.timer invalidate];
//        self.progressPercent=ORIGINAL_PERCENT;
//    }
}

@end
