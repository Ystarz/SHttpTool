
//  HttpManager.m
//  HDIM
//
//  Created by mac on 2018/12/20.
//  Copyright © 2018年 mj. All rights reserved.
//

#import "SAFNHttpTool.h"
//#import "AFHTTPSessionManager.h"
#import <AFNetworking/AFNetworking.h>

@implementation SAFNHttpTool
+(void)postWithUrl:(NSString*)url
             param:(NSString*)param
           success:(void(^)(NSDictionary *dict))success
              fail:(void (^)(NSError *error))fail
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置https需要的ssl证书
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    //manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];//不设置会报-1016或者会有编码问题
    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; //不设置会报-1016或者会有编码问题
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; //不设置会报 error 3840
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html",@"text/plain",nil]];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer]  requestWithMethod:@"POST"URLString:url parameters:nil error:nil];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSData *body=[param dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:body];
    //发起请求
    [[manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if(!error){
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            success(dic);
            //success(responseObject);
        }
        else fail(error);
    }] resume];
}

+ (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"ios" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
 //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
 //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    if (certData) {
        NSSet<NSData*> *set=[[NSSet alloc]initWithObjects:certData, nil];
        securityPolicy.pinnedCertificates =set;
//        securityPolicy.pinnedCertificates = @[certData];
    }
    else{
        securityPolicy=[AFSecurityPolicy defaultPolicy];
        securityPolicy.allowInvalidCertificates = YES;
    }
    
    return securityPolicy;
}
@end
