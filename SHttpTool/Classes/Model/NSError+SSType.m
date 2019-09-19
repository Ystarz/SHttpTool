//
//  NSError+SSType.m
//  SHttpTool
//
//  Created by SSS on 2019/9/18.
//  Copyright © 2019 SSS. All rights reserved.
//

#import "NSError+SSType.h"

NSString *const NSCommonErrorDomain = @"NSCommonErrorDomain";
@implementation NSError(SSType)

+(NSError*)errorCode:(NSCommonErrorCode)code{
    return [self errorCode:code userInfo:nil];
}

+(NSError*)errorCode:(NSCommonErrorCode)code userInfo:(nullable NSDictionary*)userInfo{
    if (userInfo) {
        return [NSError errorWithDomain:NSCommonErrorDomain code:code userInfo:userInfo];
    }else{
        return [NSError errorWithDomain:NSCommonErrorDomain code:code userInfo:
                @{
                  NSLocalizedDescriptionKey:@"返回的消息？",
                  NSLocalizedFailureReasonErrorKey:@"失败原因",
                  NSLocalizedRecoverySuggestionErrorKey:@"意见：恢复初始化",
                  @"自定义":@"自定义的内容",
                  }];
    }
}
@end

