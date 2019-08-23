//
//  STools.h
//  STools
//
//  Created by SSS on 2019/6/17.
//  Copyright © 2019 SSS. All rights reserved.
//


#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
// iOS Simulator
// iOS device
#import <UIKit/UIKit.h>
//Data
#import "NSObject+ChatAdd.h"


//! Project version number for STools.
FOUNDATION_EXPORT double SToolsVersionNumber;

//! Project version string for STools.
FOUNDATION_EXPORT const unsigned char SToolsVersionString[];

#elif TARGET_OS_MAC

// Other kinds of Mac OS
#import <Cocoa/Cocoa.h>
//#import "../Mac/NSTask+TRTaskAdditions_termination.h"
#import "NSTask+TRTaskAdditions_termination.h"
//#import "../Mac/Proccess/SProccess.h"
//#import "SProccess.h"
//! Project version number for SDataToolsLib_Mac.
FOUNDATION_EXPORT double SDataToolsLib_MacVersionNumber;

//! Project version string for SDataToolsLib_Mac.
FOUNDATION_EXPORT const unsigned char SDataToolsLib_MacVersionString[];
#else
#   error "Unknown Apple platform"
#endif



//File
#import "SFileTool.h"

//Data
#import "SNSStringTool.h"
#import "STimeTool.h"
#import "SDataConvertTool.h"
#import "SMathTool.h"

//DataClasses
#import "ArrayList.h"
#import "ArrayQueue.h"
#import "ArrayStack.h"
#import "LinkedList.h"
#import "LinkedListStack.h"
#import "LoopQueue.h"

//Other
#import "SQueue.h"
#import "STimerManager.h"


// In this header, you should import all the public headers of your framework using statements like #import <STools/PublicHeader.h>


