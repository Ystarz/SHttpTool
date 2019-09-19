//
//  HttpManager.h
//  HDIM
//
//  Created by mac on 2018/12/20.
//  Copyright © 2018年 mj. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SAFNHttpTool : NSObject
+(void)postWithUrl:(NSString*)url param:(NSString*)param success:(void(^)(NSDictionary *dict))success fail:(void (^)(NSError *error))fail;
+(void)getWithUrl:(NSString*)url param:(NSDictionary*)paramDict success:(void(^)(NSDictionary *dict))success fail:(void (^)(NSError *error))fail;
@end
