
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
#pragma mark post
+(void)postWithUrl:(NSString*)url
             param:(NSString*)param
           success:(void(^)(NSDictionary *dict))success
              fail:(void (^)(NSError *error))fail
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if ([url containsString:@"https"]) {
        //设置https需要的ssl证书
        //        NSLog(@"https");
        [manager setSecurityPolicy:[self customSecurityPolicy]];
    }
    else {
        //NSLog(@"http");
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];//不设置会报-1016或者会有编码问题
    }
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
    //这个证书根本没有
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    /*AFSSLPinningModeNone
     这个模式表示不做SSL pinning，只跟浏览器一样在系统的信任机构列表里验证服务端返回的证书。若证书是信任机构签发的就会通过，若是自己服务器生成的证书就不会通过。
     
     AFSSLPinningModeCertificate
这个模式表示用证书绑定方式验证证书，需要客户端保存有服务端的证书拷贝，这里验证分两步，第一步验证证书的域名有效期等信息，第二步是对比服务端返回的证书跟客户端返回的是否一致。
     
     AFSSLPinningModePublicKey
     这个模式同样是用证书绑定方式验证，客户端要有服务端的证书拷贝,
只是验证时只验证证书里的公钥，不验证证书的有效期等信息。只要公钥是正确的，就能保证通信不会被窃听，因为中间人没有私钥，无法解开通过公钥加密的数据。*/
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
    
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

+(void)postWithUrl:(NSString *)uploadUrl param:(NSDictionary* _Nullable)param data:(NSData*)data fileName:(NSString*)fileName mimeType:(NSString*)mime
           success:(void(^)(NSDictionary *dict))success
              fail:(void (^)(NSError *error))fail
{
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:uploadUrl parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                    {
                                        /*
                                         *该方法的参数
                                         1. appendPartWithFileData：要上传的照片[二进制流]
                                         2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
                                         3. fileName：要保存在服务器上的文件名
                                         4. mimeType：上传的文件的类型
                                         */
                                        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:mime]; //
                                        
                                    } error:nil];
    
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {

                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if(!error){
                          NSDictionary * obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                          success(obj);
                          //success(responseObject);
                      }
                      else fail(error);
                  }];
    
    [uploadTask resume];
    
}

#pragma mark get
+(void)getWithUrl:(NSString*)url
            param:(NSDictionary* _Nullable)paramDict
           success:(void(^)(NSDictionary *dict))success
              fail:(void (^)(NSError *error))fail
//-(void)getPayInfoByUrl:(NSString*)url completeBlock:(void(^)(NSDictionary *dict))complete fail:(void(^)(NSString *msg))fail
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //NSDictionary *paramDict = @{};
    if (!paramDict) {
        paramDict = @{};
    }
    //2.发送GET请求
    /*
     第一个参数:请求路径(不包含参数).NSString
     第二个参数:字典(发送给服务器的数据~参数)
     第三个参数:progress 进度回调
     第四个参数:success 成功回调
     task:请求任务
     responseObject:响应体信息(JSON--->OC对象)
     第五个参数:failure 失败回调
     error:错误信息
     响应头:task.response
     */
    [manager GET:url parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //        OCLOG(@"getPayInfoByUrl response %@\n", [responseObject class],responseObject); //JSON格式转换成字典，IOS5中自带解析类NSJSONSerialization从response中解析出数据放到字典中
        id obj = responseObject;//[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:NULL];
        if (obj){
            success(obj);
        }
        else{
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: @"responseObject is Null.",
                                       NSLocalizedFailureReasonErrorKey:@"responseObject is Null."
                                       };
            NSError*err=[[NSError alloc]initWithDomain:NSURLErrorDomain code:200 userInfo:userInfo];
            fail(err);
            //fail(@"fail after return");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
//        fail(@"fail to ask");
//        NSDictionary *userInfo = @{
//                                   NSLocalizedDescriptionKey: @"responseObject is Null.",
//                                   NSLocalizedFailureReasonErrorKey:@"responseObject is Null."
//                                   };
//        NSError*err=[[NSError alloc]initWithDomain:NSURLErrorDomain code:404 userInfo:userInfo];
        fail(error);
    }];
    
    
}
@end
