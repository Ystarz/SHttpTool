//
//  SDataConvertTool.h
//  HDIM
//
//  Created by mac on 2018/12/18.
//  Copyright © 2018年 mj. All rights reserved.
//

#import <Foundation/Foundation.h>
//#define enumToString(value)  @#value

@interface SDataConvertTool : NSObject

+(NSString*)DataToJsonString:(NSDictionary*)object;
+(NSString*)DataToJsonString:(NSDictionary*)object option:(NSJSONWritingOptions)option;
+(NSDictionary*)JsonToDic:(NSString*)json;
+(NSDictionary*)DataToDic:(NSData*)data;
+(NSArray*)JsonToArr:(NSString*)json;
+(NSArray*)DataToArr:(NSData*)data;
+(NSDictionary*)plistStrToDic:(NSString*)str;
+(long long)timeStringToTimeStamp:(NSString*)str;

//+(NSString*)enumToString:(id)enumObject;

//+(int)stringToEnum:(NSString*)str;

+(int)NSStringToInt:(NSString*)strtemp;//+(int)charNumber:(NSString*)strtemp

@end
