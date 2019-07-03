//
//  SHttpSuccessResult.m
//  SHttpTool
//
//  Created by SSS on 2019/7/3.
//  Copyright © 2019 SSS. All rights reserved.
//

#import "SHttpResult.h"

@implementation SHttpResult

+(bool)isResultSuccess:(SHttpResultType)type{
    if (type&SHttpResult_Success) {
        return true;
    }
    return false;
}


+(bool)isResultFail:(SHttpResultType)type{
    if (type&SHttpResult_Fail) {
        return true;
    }
    return false;
}


+(bool)isResultAlreadyExist:(SHttpResultType)type{
    if (type&SHttpResult_AlreadyExist) {
        return true;
    }
    return false;
}

+(bool)isResultTimeout:(SHttpResultType)type{
    if (type&SHttpResult_Timeout) {
        return true;
    }
    return false;
}

@end
