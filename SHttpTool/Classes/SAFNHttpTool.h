//
//  HttpManager.h
//  HDIM
//
//  Created by mac on 2018/12/20.
//  Copyright © 2018年 mj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface SAFNHttpTool : NSObject
+(void)postWithUrl:(NSString*)url param:(NSString*)param success:(void(^)(NSDictionary *dict))success fail:(void (^)(NSError *error))fail;
+(void)postWithUrl:(NSString *)uploadUrl param:(NSDictionary* _Nullable)param data:(NSData*)data fileName:(NSString*)fileName mimeType:(NSString*)mime
           success:(void(^)(NSDictionary *dict))success
              fail:(void (^)(NSError *error))fail;
+(void)getWithUrl:(NSString*)url param:(NSDictionary* _Nullable )paramDict success:(void(^)(NSDictionary *dict))success fail:(void (^)(NSError *error))fail;
NS_ASSUME_NONNULL_END
@end
