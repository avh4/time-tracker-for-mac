//
//  TTTimer.m
//
//  Created by __MyName__ on 2009-07-31.
//  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
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
  timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self
    selector:@selector(timerFunc:)
    userInfo:nil repeats:YES];
}

- (void)stop
{
  [timer invalidate];
  [timer release];
  timer = nil;
}

// Call this or cancel after recieving a timerHasBecomeIdle delegate call
- (void)resume
{
  [timer setFireDate: [NSDate dateWithTimeIntervalSinceNow: 1]];
}

// Call this or resume after recieving a timerHasBecomeIdle delegate call
- (void)cancel
{
  [lastNonIdleTime release];
  lastNonIdleTime = nil;
}

- (NSDate *)lastNonIdleTime
{
  return lastNonIdleTime;
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

@end
