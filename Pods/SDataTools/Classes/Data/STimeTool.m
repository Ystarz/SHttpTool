//
//  STimeTool.m
//  HDIM
//
//  Created by mac on 2018/12/20.
//  Copyright © 2018年 mj. All rights reserved.
//

#import "STimeTool.h"

@implementation STimeTool
+(NSString*)getNowTime:(NSDateFormatter *)dateFormatter{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
   return [dateFormatter stringFromDate:date];
}


+(long long)getNowTimeStamp{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到
    return  [[NSNumber numberWithDouble:time] longLongValue];
}

+(int)getNowTimeStampInt{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到ms
    return  [[NSNumber numberWithDouble:time] intValue];
}

/**
 * 计算两日期之间时间之差
 * date1<date2
 */
+(long long) compareDate1:(NSDate *)date1 withDate2:(NSDate *)date2 type:(int)type
{
    NSTimeInterval  timeInterval = [date1 timeIntervalSinceDate:date2];
    timeInterval = -timeInterval;
    long long result = 0;
    switch (type) {
        case 1:
            result = (long long)timeInterval;    //秒
            break;
        case 2:
            result = (long long)timeInterval/60;    //分
            break;
        case 3:
            result = (long long)timeInterval/60/60;    //时
            break;
        case 4:
            result = (long long)timeInterval/60/60/24;    //天
            break;
        case 5:
            result = (long long)timeInterval/60/60/24/30;    //月
            break;
        case 6:
            result = (long long)timeInterval/60/60/24/365;    //年
            break;
        default:
            break;
    }
    return result;
}

+(NSString *)timeStampToString:(NSTimeInterval)timeStamp {
    
    NSString *timeString = [[NSString alloc]init];
    
    //当前时间的时间戳
    NSTimeInterval  timeNow=[[NSDate date] timeIntervalSince1970];
    
    //将传来的时间戳转为标准时间格式
    NSTimeInterval time = timeStamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *tempStr= [dateFormatter stringFromDate:date];
    
    timeString = [NSString stringWithFormat:@"%@年%@月%@日 %@",[tempStr substringWithRange:NSMakeRange(0,4)],[tempStr substringWithRange:NSMakeRange(5,2)],[tempStr substringWithRange:NSMakeRange(8,2)],[tempStr substringWithRange:NSMakeRange(11,8)]];
    
    //当前时间
    NSDate *nowDate = [NSDate date];
    NSString *nowDateStr= [dateFormatter stringFromDate:nowDate];
    
    //时间戳判断逻辑
    if ([[timeString substringWithRange:NSMakeRange(0, 4)] isEqualToString:[nowDateStr substringWithRange:NSMakeRange(0, 4)]]) {
        
        if ([[timeString substringWithRange:NSMakeRange(5,2)] isEqualToString:[nowDateStr substringWithRange:NSMakeRange(5,2)]]) {
            
            float daySubtract = [[nowDateStr substringWithRange:NSMakeRange(8,2)] floatValue] - [[timeString substringWithRange:NSMakeRange(8,2)] floatValue];
            
            if (daySubtract < 3) {
                
                if (daySubtract == 0) {
                    
                    NSString *string = [NSString stringWithFormat:@"今天 %@",[timeString substringWithRange:NSMakeRange(11,6)]];
                    return  string;
                    
                }else if (daySubtract == 1) {
                    
                    NSString *string = [NSString stringWithFormat:@"昨天 %@",[timeString substringWithRange:NSMakeRange(11,6)]];
                    return  string;
                }else {
                    
                    if ((timeNow - time) > 3600*24*2) {
                        
                        return timeString;
                    }else {
                        
                        NSString *string = [NSString stringWithFormat:@"前天 %@",[timeString substringWithRange:NSMakeRange(11,6)]];
                        return  string;
                    }
                    
                }
                
            }else{
                
                return timeString;
            }
            
        }else {
            return timeString;
            
        }
        
    }else {
        
        return timeString;
    }
    
}


@end
