//
//  NSString+SExtension.m
//  HDIM
//
//  Created by SSS on 2019/4/1.
//  Copyright © 2019 mj. All rights reserved.
//
//
#import "NSString+SExtension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString(SExtension)

+(bool)isNull:(NSString*)str{
    if (str==nil||[str isEqualToString:@""]) {
        return true;
    }
    return false;
}

-(NSString*)md5 {
    NSString *str=self;
    const char *myPasswd = [str UTF8String ];
    
    unsigned char mdc[ 16 ];
    
    CC_MD5 (myPasswd, ( CC_LONG ) strlen (myPasswd), mdc);
    
    NSMutableString *md5String = [ NSMutableString string ];
    
    for ( int i = 0 ; i< 16 ; i++) {
        [md5String appendFormat : @"%02x" ,mdc[i]];
    }
    return md5String;
}

+(NSString *)removeSpaceAndNewline:(NSString *)str
{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}

+(NSString *)removeNewline:(NSString *)str
{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}
@end
