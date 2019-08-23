//
//  STimerManager.h
//  SMultithreadingBlockTest
//
//  Created by SSS on 2019/8/20.
//  Copyright © 2019 SSS. All rights reserved.
//

#import <Foundation/Foundation.h>
#define TIME_UPDATE_NOTICE @"kNetworkReachabilityChangedNotification"
NS_ASSUME_NONNULL_BEGIN
typedef void (^TimerBlock)(NSNumber* currentTime,id obj);
//typedef void (^AFURLSessionTaskDidSendBodyDataBlock)(NSURLSession *session, NSURLSessionTask *task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend);


@interface STimerManager : NSObject
+ (instancetype)sharedInstance;
-(void)start;
-(void)startWithLog:(bool)islog;
//-(void)disturb;
@end

NS_ASSUME_NONNULL_END
