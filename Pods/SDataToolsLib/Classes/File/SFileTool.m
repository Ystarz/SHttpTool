//
//  SFileTool.m
//  PackTest_App2
//
//  Created by SSS on 2019/5/14.
//  Copyright © 2019 SSS. All rights reserved.
//

#import "SFileTool.h"
#include <CommonCrypto/CommonDigest.h>
#define FileHashDefaultChunkSizeForReadingData 1024*8 

@implementation SFileTool

+(NSArray*)getTextArrFromFile:(NSString*)filePath{
    NSArray *fileData;
    NSError *error;
    
    //读取file文件并把内容根据换行符分割后赋值给NSArray
    fileData = [[NSString stringWithContentsOfFile:filePath
                                          encoding:NSUTF8StringEncoding
                                             error:&error]
                componentsSeparatedByString:@"\n"];
    return fileData;
    
    
    }

+(void) writeToFile:(NSString *)path contentArr:(NSArray *)arr{
//    NSError *error = nil;
    NSString *str=@"";
    for (NSString*line in arr) {
        str=[[str stringByAppendingString:line]stringByAppendingString:@"\n"];
    }
    [SFileTool writeToFile:path content:str];
}

+(void) writeToFile:(NSString *)path content:(NSString *)str{
    NSError *error = nil;
    //atomically : YES时，没有写完，则会全部撤销；NO时候，没有写完，不会撤销
    //注意：这种写入方式，如果文件补存在，则创建；如果文件存在，则覆盖原文件的内容
    BOOL flag = [str writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];//一般error都设置为nil，保证写入成功
    if (flag) {
        NSLog(@"写入成功");
    }
    else{
        NSLog(@"写入失败");
    }
}

+(bool)createDir:(NSString*)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //直接创建目标目录，中间目录会自动补全
   return [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
}

+(bool)isDirExist:(NSString*)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir=true;
    return [fileManager fileExistsAtPath:path isDirectory:&isDir];
}

+(bool)isFileExist:(NSString*)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir=false;
    return [fileManager fileExistsAtPath:path isDirectory:&isDir];
}

+(bool)renameAtPath:(NSString*)filePath to:(NSString*)destinationPath isForce:(bool)force{
    return [SFileTool moveFile:filePath to:destinationPath isForce:force];
}

+(bool)moveFile:(NSString*)filePath to:(NSString*)destinationPath isForce:(bool)force{
    if ([SFileTool isFileExist:destinationPath]&&!force) {
        return true;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager moveItemAtPath:filePath toPath:destinationPath error:nil];
}


+(bool)copyFile:(NSString*)filePath to:(NSString*)destinationPath isForce:(bool)force{
    if ([SFileTool isFileExist:destinationPath]&&!force) {
        return true;
    }
     NSFileManager *fileManager = [NSFileManager defaultManager];
   return [fileManager copyItemAtPath:filePath toPath:destinationPath error:nil];
}

+(bool)deleteFile:(NSString*)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir=false;
    if([fileManager fileExistsAtPath:path isDirectory:&isDir]){
       return [fileManager removeItemAtPath:path error:nil];
    }
    else{
        return true;}
}

+(NSString*)fileMD5:(NSString*)path

{
    
    return (__bridge_transfer NSString *)FileMD5HashCreateWithPath((__bridge CFStringRef)path, FileHashDefaultChunkSizeForReadingData);
    
}



//+(NSString*)fileMD5:(NSString*)path
//{
//    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
//    if( handle== nil ) return FILENOTEXIST;//return @"ERROR GETTING FILE MD5"; // file didnt exist
//
//    CC_MD5_CTX md5;
//
//    CC_MD5_Init(&md5);
//
//    BOOL done = NO;
//    while(!done)
//    {
//        NSData* fileData = [handle readDataOfLength:1024];
////        NSData* fileData = [handle readDataOfLength:256];
//        //        CHUNK_SIZE
//        CC_MD5_Update(&md5, [fileData bytes], [fileData length]);
//        if( [fileData length] == 0 ) done = YES;
//    }
//    unsigned char digest[CC_MD5_DIGEST_LENGTH];
//    CC_MD5_Final(digest, &md5);
//    NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
//                   digest[0], digest[1],
//                   digest[2], digest[3],
//                   digest[4], digest[5],
//                   digest[6], digest[7],
//                   digest[8], digest[9],
//                   digest[10], digest[11],
//                   digest[12], digest[13],
//                   digest[14], digest[15]];
//    return s;
//}

CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath,size_t chunkSizeForReadingData) {
    // Declare needed variables
    
    CFStringRef result = NULL;
    
    CFReadStreamRef readStream = NULL;
    
    // Get the file URL
    
    CFURLRef fileURL =
    
    CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                  
                                  (CFStringRef)filePath,
                                  
                                  kCFURLPOSIXPathStyle,
                                  
                                  (Boolean)false);
    
    if (!fileURL) goto done;
    
    // Create and open the read stream
    
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                            
                                            (CFURLRef)fileURL);
    
    if (!readStream) goto done;
    
    bool didSucceed = (bool)CFReadStreamOpen(readStream);
    
    if (!didSucceed) goto done;
    
    // Initialize the hash object
    
    CC_MD5_CTX hashObject;
    
    CC_MD5_Init(&hashObject);
    
    // Make sure chunkSizeForReadingData is valid
    
    if (!chunkSizeForReadingData) {
        
        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
        
    }
    
    // Feed the data to the hash object
    
    bool hasMoreData = true;
    
    while (hasMoreData) {
        
        uint8_t buffer[chunkSizeForReadingData];
        
        CFIndex readBytesCount = CFReadStreamRead(readStream,(UInt8 *)buffer,(CFIndex)sizeof(buffer));
        
        if (readBytesCount == -1) break;
        
        if (readBytesCount == 0) {
            
            hasMoreData = false;
            
            continue;
            
        }
        
        CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
        
    }
    
    // Check if the read operation succeeded
    
    didSucceed = !hasMoreData;
    
    // Compute the hash digest
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5_Final(digest, &hashObject);
    
    // Abort if the read operation failed
    
    if (!didSucceed) goto done;
    
    // Compute the string result
    
    char hash[2 * sizeof(digest) + 1];
    
    for (size_t i = 0; i < sizeof(digest); ++i) {
        
        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
        
    }
    
    result = CFStringCreateWithCString(kCFAllocatorDefault,(const char *)hash,kCFStringEncodingUTF8);
    
    
    
done:
    
    if (readStream) {
        
        CFReadStreamClose(readStream);
        
        CFRelease(readStream);
        
    }
    
    if (fileURL) {
        
        CFRelease(fileURL);
        
    }
    
    return result;
    
}



+(long long) getFileBytes:(NSString *)path
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize =size;// 1.0*size/1024;
    }
    return filesize;
}
@end
