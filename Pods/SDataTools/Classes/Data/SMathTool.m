//
//  SMathTool.m
//  SDataTools
//
//  Created by SSS on 2019/8/21.
//  Copyright © 2019 SSS. All rights reserved.
//

#import "SMathTool.h"

@implementation SMathTool
-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}
@end
