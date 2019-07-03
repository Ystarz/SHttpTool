//
//  SHttpSuccessResult.h
//  SHttpTool
//
//  Created by SSS on 2019/7/3.
//  Copyright © 2019 SSS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, SHttpResultType){
    SHttpResult_Success=1<<0,
    SHttpResult_Fail=1<<1,
    SHttpResult_Timeout=1<<2,
    SHttpResult_AlreadyExist=1<<3,
} ;

NS_ASSUME_NONNULL_BEGIN

@interface SHttpResult : NSObject
@property(assign,nonatomic)SHttpResultType type;
@property(strong,nonatomic)NSString* result;
@property(strong,nonatomic)NSData* data;
@property(strong,nonatomic)NSError* errorData;
@property(strong,nonatomic)NSDictionary* jsonData;
@end

NS_ASSUME_NONNULL_END
