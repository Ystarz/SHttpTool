//
//  SHttpTool2.h
//  SHttpTool
//
//  Created by SSS on 2019/7/3.
//  Copyright © 2019 SSS. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "SHttpResult.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^SHttpResultBlock)(SHttpResult*result);
@interface SHttpTool2 : NSObject
@property (strong,nonatomic) NSMutableDictionary<NSString*,NSNumber*>* activePool;
@property (assign,nonatomic) int maxRepeatCount;
@property (assign,nonatomic) float repeatDelay;

+(instancetype)sharedInstance;
+(void)postWithUrl:(NSString*)url param:(NSString*)param success:(void(^)(SHttpResult *result))success fail:(void (^)(SHttpResult *result))fail;
+(void)postWithUrl:(NSString *)url param:(NSDictionary* _Nullable)param data:(NSData*)data fileName:(NSString*)fileName mimeType:(NSString*)mime success:(SHttpResultBlock) success fail:(SHttpResultBlock) fail;
+(void)getWithUrl:(NSString*)url param:(NSDictionary* _Nullable)param success:(void(^)(SHttpResult *result))success fail:(void (^)(SHttpResult *result))fail;
@end

NS_ASSUME_NONNULL_END
