//
//  NSTimer+SSAdd.h
//  SSChatView
//
//  Created by soldoros on 2018/10/10.
//  Copyright © 2018年 soldoros. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSTimer (ChatAdd)

//获取当前时间的时间戳
+(long long)getLocationTimeStamp;

//获取当前时间(YYYY-MM-dd HH:mm:ss)
+(NSString *)getLocationTime;

//时间(YYYY-MM-dd HH:mm:ss) 转换成时间戳
+(long long)getStampWithTime:(NSString *)time;

//时间戳转换成时间(YYYY-MM-dd HH:mm:ss)
+ (NSString *)getTimeWithTimeStamp:(long long)timeStamp;

//聊天时间显示
+ (NSString *)getChatTimeStr:(long long)timestamp;

//聊天时间显示2
+ (NSString *)getChatTimeStr2:(long long)timestamp;

//两个时间戳的时间差(秒)
+ (NSTimeInterval)CompareTwoTime:(long long)time1 time2:(long long)time2;

//两个时间(YYYY-MM-dd HH:mm:ss) 的时间差(秒)
+ (NSTimeInterval)CompareTwoTimer:(NSString *)timer1 time2:(NSString *)timer2;



@end


