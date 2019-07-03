//
//  SHttpTool2.m
//  SHttpTool
//
//  Created by SSS on 2019/7/3.
//  Copyright © 2019 SSS. All rights reserved.
//

#import "SHttpTool2.h"
#import "SAFNHttpTool.h"
#import <SDataTools/SDataTools.h>

#define MAX_REPEAT_COUNT 10
#define REPEAT_DELAY 1

@implementation SHttpTool2
+ (instancetype)sharedInstance
{
    static SHttpTool2 *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.maxRepeatCount=MAX_REPEAT_COUNT;
        self.repeatDelay=REPEAT_DELAY;
    }
    return self;
}

+(void)postWithUrl:(NSString*)url param:(NSString*)param success:(SHttpResultBlock) success fail:(SHttpResultBlock) fail{
    bool isCanAdd=  [[SHttpTool2 sharedInstance]addToActivePoolWithUrl:url];
    if (!isCanAdd) {
        [[SHttpTool2 sharedInstance]rejectRequest:fail];
    }
    [SHttpTool2 doPostWithUrl:url param:param success:success fail:fail];
}

+(void)doPostWithUrl:(NSString*)url param:(NSString*)param success:(SHttpResultBlock) success fail:(SHttpResultBlock) fail {
    [SAFNHttpTool postWithUrl:url param:param success:^(NSDictionary *dict) {
        [[SHttpTool2 sharedInstance]success:url resultBlock:success withData:dict];
    } fail:^(NSError *error) {
        if ([[SHttpTool2 sharedInstance]isRepeatRequest:url]) {
            [SHttpTool2 doPostWithUrl:url param:param success:success fail:fail];
            return ;
        }
        [[SHttpTool2 sharedInstance]fail:url resultBlock:fail withData:error];
    }];
}



+(void)postForceWithUrl:(NSString*)url param:(NSString*)param success:(void(^)(SHttpResult *result))success fail:(void (^)(SHttpResult *result))fail{
    
}

-(bool)isRepeatRequest:(NSString*)url{
    int repeatCount=[[self getRequestCountFromActivePool:url] intValue];
    if (repeatCount>self.maxRepeatCount) {
        return false;
    }
    [self.activePool setValue:@(repeatCount+1) forKey:[url md5]];
    return true;
}


-(NSNumber*)getRequestCountFromActivePool:(NSString*)url{
    if (!self.activePool) {
        self.activePool=[NSMutableDictionary new];
        return @(-1);
    }
    NSString*md5=[url md5];
    if ([self.activePool.allKeys containsObject:md5]) {
        return self.activePool[md5];
    }
    return @(-1);
}


-(bool)addToActivePoolWithUrl:(NSString*)url{
    if (!self.activePool) {
        self.activePool=[NSMutableDictionary new];
    }
    NSString*md5=[url md5];
    if ([self.activePool.allKeys containsObject:md5]) {
        return false;
    }
    [self.activePool setValue:@(0) forKey:md5];
    return true;
}


-(void)removeFromActivePool:(NSString*)url{
    if (!self.activePool) {
        self.activePool=[NSMutableDictionary new];
    }
    NSString*md5=[url md5];
    if (![self.activePool.allKeys containsObject:md5]) {
        return ;
    }
    
    [self.activePool removeObjectForKey:md5];
    return ;
}

#pragma mark 返回结果

-(void)success:(NSString*)url resultBlock:(SHttpResultBlock) block withData:(NSObject*)data{
    [self removeFromActivePool:url];
    
    SHttpResult*result=[SHttpResult new];
    //  result.type=SHttpResult_Fail|SHttpResult_AlreadyExist;
    result.type=SHttpResult_Success;
    result.result=@"the request is Success";
    if ([data isKindOfClass:[NSData class]]) {
        result.data=(NSData*)data;
    }
    else if ([data isKindOfClass:[NSDictionary class]]){
        result.jsonData=(NSDictionary*)data;
    }
    else if ([data isKindOfClass:[NSString class]]){
        result.result=(NSString*)data;
    }
    block(result);
}

-(void)fail:(NSString*)url resultBlock:(SHttpResultBlock) block withData:(NSObject*)data{
    SHttpResult*result=[SHttpResult new];
    [self removeFromActivePool:url];
    //  result.type=SHttpResult_Fail|SHttpResult_AlreadyExist;
    result.type=SHttpResult_Fail;
    result.result=@"the url is fail to reach after many times try";
    if ([data isKindOfClass:[NSError class]]) {
        result.errorData=(NSError*)data;
    }
    else if ([data isKindOfClass:[NSString class]]){
        result.result=(NSString*)data;
    }
    block(result);
}


-(void)timeout:(NSString*)url resultBlock:(SHttpResultBlock) block withData:(NSObject*)data{
    [self removeFromActivePool:url];
    SHttpResult*result=[SHttpResult new];
    //  result.type=SHttpResult_Fail|SHttpResult_AlreadyExist;
    result.type=SHttpResult_Timeout;
    result.result=@"the request is timeout to reach after many times try";
    if ([data isKindOfClass:[NSError class]]) {
        result.errorData=(NSError*)data;
    }
    else if ([data isKindOfClass:[NSString class]]){
        result.result=(NSString*)data;
    }
    block(result);
}

-(void)rejectRequest:(SHttpResultBlock) block{
    SHttpResult*result=[SHttpResult new];
//  result.type=SHttpResult_Fail|SHttpResult_AlreadyExist;
    result.type=SHttpResult_Fail|SHttpResult_AlreadyExist;
    result.result=@"the url is in request list,you can't do request through this url until the eariler one has been done.";
    block(result);
}
@end
