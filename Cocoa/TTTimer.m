//
//  TTTimer.m
//
//  Created by Aaron VonderHaar on 2009-07-31.
//  Copyright (c) 2009 Aaron VonderHaar. All rights reserved.
//

#import "TTTimer.h"

@implementation TTTimer

- (id)initWithDelegate:(id)aDelegate
{
  self = [super init];
  delegate = aDelegate;
  return self;
}

- (void)dealloc
{
  [timer invalidate];
  [timer release];
  [super dealloc];
}

- (BOOL)isRunning
{
  return timer != nil;
}

- (void)start
{
  assert(timer == nil);
  timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self
    selector:@selector(timerFunc:)
    userInfo:nil repeats:YES];
  [timer retain];
}

- (void)stop
{
  assert(timer != nil);
  [timer invalidate];
  [timer release];
  timer = nil;
  [delegate timerHasChanged:[NSDate date]];
}

// Call this or cancel after recieving a timerHasBecomeIdle delegate call
- (void)resume
{
  [timer setFireDate: [NSDate dateWithTimeIntervalSinceNow: 1]];
}

// Call this or resume after recieving a timerHasBecomeIdle delegate call
- (void)cancel
{
  [delegate timerHasChanged:lastNonIdleTime];
  [lastNonIdleTime release];
  lastNonIdleTime = nil;
}

- (NSDate *)currentTime
{
  return [NSDate date];
}

- (void)timerFunc:(NSTimer *)atimer
{ 
  if (timer != atimer) return;
  
  [delegate timerHasChanged:[NSDate date]];
  
  int idleTime = [self idleTime];
  if (idleTime == 0) {
    [lastNonIdleTime release];
    lastNonIdleTime = [[NSDate date] retain];
  }
  if (idleTime > 5 * 60) {
    [timer setFireDate:[NSDate distantFuture]];
    [delegate timerHasBecomeIdle];
  }
  
}

- (int)idleTime
{
  mach_port_t masterPort;
  io_iterator_t iter;
  io_registry_entry_t curObj;
  int res = 0;
  
  IOMasterPort(MACH_PORT_NULL, &masterPort);
  
  IOServiceGetMatchingServices(masterPort,
                 IOServiceMatching("IOHIDSystem"),
                 &iter);
  if (iter == 0) {
    return 0;
  }
  
  curObj = IOIteratorNext(iter);
  
  if (curObj == 0) {
    return 0;
  }
  
  CFMutableDictionaryRef properties = 0;
  CFTypeRef obj;
  
  if (IORegistryEntryCreateCFProperties(curObj, &properties,
                   kCFAllocatorDefault, 0) ==
      KERN_SUCCESS && properties != NULL) {
    
    obj = CFDictionaryGetValue(properties, CFSTR("HIDIdleTime"));
    CFRetain(obj);
  } else {
    obj = NULL;
  }
  
  if (obj) {
    uint64_t tHandle;
    
    CFTypeID type = CFGetTypeID(obj);
    
    if (type == CFDataGetTypeID()) {
      CFDataGetBytes((CFDataRef) obj,
           CFRangeMake(0, sizeof(tHandle)),
           (UInt8*) &tHandle);
    }  else if (type == CFNumberGetTypeID()) {
      CFNumberGetValue((CFNumberRef)obj,
             kCFNumberSInt64Type,
             &tHandle);
    } else {
      return 0;
    }
    
    CFRelease(obj);
    
    // essentially divides by 10^9
    tHandle >>= 30;
    res = tHandle;
  } else {
  }
  
  /* Release our resources */
  IOObjectRelease(curObj);
  IOObjectRelease(iter);
  CFRelease((CFTypeRef)properties);
  
  return res;
}

@end
