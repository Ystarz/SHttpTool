//
//  SQueue.h
//  SDataTools
//
//  Created by SSS on 2019/6/19.
//  Copyright © 2019 SSS. All rights reserved.
//

#ifndef SQueue_h
#define SQueue_h

#define QUEUE_HIGH dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
#define QUEUE_DEFAULT dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define QUEUE_LOW dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
#define QUEUE_BACKGROUND dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)

#define QUEUE_MAIN(block) dispatch_async(dispatch_get_main_queue(), ^{block})
#define QUEUE_ASYNC_DEFAULT(block) dispatch_async(QUEUE_DEFAULT, ^{block})
#define QUEUE_ASYNC_LOW(block) dispatch_async(QUEUE_LOW, ^{block})
#define QUEUE_ASYNC_HIGH(block) dispatch_async(QUEUE_HIGH, ^{block})
#define QUEUE_ASYNC_BACKGROUND(block) dispatch_async(QUEUE_BACKGROUND, ^{block})

#endif /* SQueue_h */
