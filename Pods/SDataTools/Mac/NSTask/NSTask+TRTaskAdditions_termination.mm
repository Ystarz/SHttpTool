


#import "NSTask+TRTaskAdditions_termination.h"
#include <signal.h>

@implementation NSTask (TRTaskAdditions_termination)

- (BOOL)waitUntilExitWithTimeout:(CFTimeInterval)TO sendTerm:(BOOL)SENDTERM sendKill:(BOOL)SENDKILL
{
    CFAbsoluteTime      started;
    CFAbsoluteTime      passed;
    BOOL                exited = NO;
    
    started = CFAbsoluteTimeGetCurrent();
    for (
         CFAbsoluteTime now = started;
         !exited && ((passed = now - started) < TO);
         now = CFAbsoluteTimeGetCurrent()
         )
    {
        if (![self isRunning])
        {
            exited = YES;
        } else {
            
            CFAbsoluteTime sleepTime = 0.1;
            useconds_t sleepUsec = round(sleepTime * 1000000.0);
            if (sleepUsec == 0) sleepUsec = 1;
            usleep(sleepUsec); // sleep for 0.1 sec
            
        }
    }
    
    if (!exited)
    {
        //NSLog(@"%@ didn't exit after timeout of %0.2f sec", self, TO);
        
        if (SENDTERM)
        {
            TO = 2; // 2 second timeout, waiting for SIGTERM to kill process
            
            //NSLog(@"%@ sending SIGTERM", self);
            [self terminate];
            /* // UNIX way
             pid_t pid = [self processIdentifier];
             kill(pid, SIGTERM);
             */
            
            started = CFAbsoluteTimeGetCurrent();
            for (
                 CFAbsoluteTime now = started;
                 !exited && ((passed = now - started) < TO);
                 now = CFAbsoluteTimeGetCurrent()
                 )
            {
                if (![self isRunning])
                {
                    exited = YES;
                } else {
                    usleep(100000);
                }
            }
        }
        
        if (!exited && SENDKILL)
        {
            TO = 2; // 2 second timeout, waiting for SIGKILL to kill process
            
            //NSLog(@"%@ sending SIGKILL", self);
            pid_t pid = [self processIdentifier];
            kill(pid, SIGKILL);
            
            started = CFAbsoluteTimeGetCurrent();
            for (
                 CFAbsoluteTime now = started;
                 !exited && ((passed = now - started) < TO);
                 now = CFAbsoluteTimeGetCurrent()
                 )
            {
                if (![self isRunning])
                {
                    exited = YES;
                } else {
                    usleep(100000); // sleep for 0.1 sec
                }
            }
        }
    }
    
    return exited;
}

@end
