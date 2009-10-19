//
//  TTTimer.h
//
//  Created by Aaron VonderHaar on 2009-07-31.
//  Copyright (c) 2009 Aaron VonderHaar. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TTTimer : NSObject
{
  NSTimer *timer;
  NSDate *lastNonIdleTime;
  id delegate; // XXX make this a formal protocol
}

- (id)initWithDelegate:(id)aDelegate;

- (BOOL)isRunning;
- (void)start;
- (void)stop;
- (void)resume;
- (void)cancel;
- (NSDate *)currentTime;

// Private methods
- (int)idleTime;

@end
