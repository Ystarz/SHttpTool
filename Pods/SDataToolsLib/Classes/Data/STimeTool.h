//
//  STimeTool.h
//  HDIM
//
//  Created by mac on 2018/12/20.
//  Copyright © 2018年 mj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STimeTool : NSObject
+(NSString*)getNowTime:(NSDateFormatter *)dateFormatter;
+(long long)getNowTimeStamp;
+(long long) compareDate1:(NSDate *)date1 withDate2:(NSDate *)date2 type:(int)type;
///由时间戳转为时间格式
+(NSString *)timeStampToString:(NSTimeInterval)timeStamp;
@end
