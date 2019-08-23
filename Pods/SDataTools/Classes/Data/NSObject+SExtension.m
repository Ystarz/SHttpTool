//
//  NSObject+SExtension.m
//  HDIM
//
//  Created by SSS on 2019/8/17.
//  Copyright © 2019 mj. All rights reserved.
//

#import "NSObject+SExtension.h"
#import <SDataTools/SDataTools.h>

@implementation NSObject(SExtension)
+(bool)isNull:(NSObject*) obj{
    if (!obj) {
        return !false;
    }
    //尝试对数字int等做分析 
    if (![obj isKindOfClass:[NSObject class]]) {
        return false;
    }
    if ([obj isKindOfClass:[NSNull class]]) {
        return !false;
    }
    if (((NSNull *)obj) == [NSNull null]) {
        return !false;
    }
    if ([obj isKindOfClass:[NSString class]]&&[NSString isNull:(NSString*)obj]) {
         return !false;
    }
    return !true;
}

+ (bool)isNotNull:(NSObject *)obj{
    return ![NSObject isNull:obj];
}
@end
