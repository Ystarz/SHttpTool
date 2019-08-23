//
//  NSObject+SExtension.h
//  HDIM
//
//  Created by SSS on 2019/8/17.
//  Copyright © 2019 mj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject(SExtension)
+(bool)isNull:(NSObject*) obj;
+(bool)isNotNull:(NSObject*) obj;
@end

NS_ASSUME_NONNULL_END
