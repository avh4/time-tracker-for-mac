//
//  TTTimer.h
//
//  Created by __MyName__ on 2009-07-31.
//  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
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
- (NSDate *)lastNonIdleTime;

@end
