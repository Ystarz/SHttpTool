//
//  SMathTool.h
//  SDataTools
//
//  Created by SSS on 2019/8/21.
//  Copyright © 2019 SSS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMathTool : NSObject
/**
 指定范围的随机数[左闭右闭]

 @param from 起始
 @param to 终结
 @return 随机数
 */
-(int)getRandomNumber:(int)from to:(int)to;
@end

NS_ASSUME_NONNULL_END
