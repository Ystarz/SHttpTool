//
//  SDataConvertTool.m
//  HDIM
//
//  Created by mac on 2018/12/18.
//  Copyright © 2018年 mj. All rights reserved.
//

#import "SDataConvertTool.h"
#import <Foundation/Foundation.h>
#import "NSString+SExtension.h"
////enum
//typedef enum : NSUInteger {
//    AVCapturePresetQualityHigh = 0,
//    AVCapturePresetQualityNormal,
//    AVCapturePresetQualityLow,
//} AVCaptureSessionPresetQuality;
//
////declare an array contains all cases
//const NSArray *__captureQualityA;
//
////macro for array creation
//#ifndef AVCaptureQuality
//#define AVCaptureQuality \
//(__captureQualityA == nil ? __captureQualityA = \
//@[AVCaptureSessionPreset1920x1080,\
//AVCaptureSessionPreset1280x720,\
//AVCaptureSessionPreset640x480]\
//: __captureQualityA)
//#endif
//
////enum and string transform
////enum -> string
//#ifndef kGetCapturePresetString
//#define kGetCapturePresetString(idx) \
//([AVCaptureQuality objectAtIndex:idx])
//#endif
////string -> enum
//#ifndef kGetCapturePresetEnum
//#define kGetCapturePresetEnum(string) \
//([AVCaptureQuality indexOfObject:string])
//#endif

@implementation SDataConvertTool

+(NSString*)DataToJsonString:(NSDictionary*)object{
    if (@available(iOS 11.0, *)) {
        return [SDataConvertTool DataToJsonString:object option:NSJSONWritingSortedKeys];
    } else {
        NSString*str=[SDataConvertTool DataToJsonString:object option:NSJSONWritingPrettyPrinted];
        str=[NSString removeNewline:str];
        return str;
    }
}



+(NSString*)DataToJsonString:(NSDictionary*)object option:(NSJSONWritingOptions)option 
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:option // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        //TODO:还有个编码格式的问题,现在默认utf-8
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

+(NSDictionary*)JsonToDic:(NSString*)json{
    // JSON格式转换成字典，IOS5中自带解析类NSJSONSerialization从response中解析出数据放到字典中
    if ([NSString isNull:json]) {
        return nil;
    }
    NSData*data=[json dataUsingEncoding:NSUTF8StringEncoding];
    return [SDataConvertTool DataToDic:data];
}

+(NSDictionary*)DataToDic:(NSData*)data{
    // JSON格式转换成字典，IOS5中自带解析类NSJSONSerialization从response中解析出数据放到字典中
    if (data==nil) {
        return nil;
    }
    NSDictionary* obj = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    return obj;
}

+(long long)timeStringToTimeStamp:(NSString*)str{
    // 日期格式化类
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    // 设置日期格式 为了转换成功
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // NSString * -> NSDate *
    NSDate *date = [format dateFromString:str];
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到ms
    //NSString *newString = [format stringFromDate:data];
    
    return time;
}
//+(NSString*)enumToString:(id)enumObject{
//    return enumToString(enumObject);//kGetCapturePresetString(enumObject);
//}

//+(int)stringToEnum:(NSString*)str{
//    return 0;//kGetCapturePresetEnum(str);
//}



+(int)NSStringToInt:(NSString*)strtemp {
    
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}
@end
