//
//  NSTask+SAdd.h
//  PackTest_App2
//
//  Created by SSS on 2019/6/26.
//  Copyright © 2019 SSS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTask (TRTaskAdditions_termination)

// This method mitigates the infinite-blocking potential of [NSThread waitUntilExit]
//
// Returns a BOOL indicating whether or not the process exited.
//
// Inputs:
// TO: The initial timeout, during which time we wait for the task to exit. (There are additional timeouts if SENTERM or SENDKILL are YES.
// SENDTERM: If we don't exit during the initial timeout, send SIGTERM and wait 2 seconds.
// SENDKILL: If we still haven't exited, send SIGKILL and wait 2 seconds.
//
// The method runs as follows:
// Step 1: Poll [self isRunning] for (TO) seconds. If the task stops running during that time, we return immediately with YES
// Step 2: If the task didn't exit after (TO) seconds, we send it a SIGTERM if (SENDTERM == YES). Wait 2 seconds for the task to exit.
// Step 3: If the task exits, return YES. If it _still_ hasn't exited (i.e. it ignored the SIGTERM,) send it a SIGKILL if (SENDKILL == YES).
// Step 4: Wait another 2 seconds for the task to end. If it exits, return YES. Otherwise, if the task is still running, return NO.
//
// In theory, setting SENDKILL to YES should terminate any process. Processes aren't supposed to be able to escape signal #9 (KILL).
- (BOOL)waitUntilExitWithTimeout:(CFTimeInterval)TO sendTerm:(BOOL)SENDTERM sendKill:(BOOL)SENDKILL;

@end


NS_ASSUME_NONNULL_END
