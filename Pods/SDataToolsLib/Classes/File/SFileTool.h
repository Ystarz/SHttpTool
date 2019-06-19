//
//  SFileTool.h
//  PackTest_App2
//
//  Created by SSS on 2019/5/14.
//  Copyright © 2019 SSS. All rights reserved.
//

#import <Foundation/Foundation.h>
#define FILENOTEXIST @"file not exist"

NS_ASSUME_NONNULL_BEGIN

@interface SFileTool : NSObject
+(NSArray*)getTextArrFromFile:(NSString*)filePath;
+(void) writeToFile:(NSString *)path contentArr:(NSArray *)arr;
+(bool)createDir:(NSString*)path;
+(bool)isFileExist:(NSString*)path;
+(bool)isDirExist:(NSString*)path;
+(bool)copyFile:(NSString*)filePath to:(NSString*)destinationPath isForce:(bool)force;
+(bool)moveFile:(NSString*)filePath to:(NSString*)destinationPath isForce:(bool)force;
+(bool)renameAtPath:(NSString*)filePath to:(NSString*)destinationPath isForce:(bool)force;
+(bool)deleteFile:(NSString*)path;

+(NSString*)fileMD5:(NSString*)path;

+(long long) getFileBytes:(NSString *)path;
@end

NS_ASSUME_NONNULL_END
