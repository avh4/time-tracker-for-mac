//
//  TTTimer.h
//  Time Tracker
//
//  Created by Aaron VonderHaar on 4/12/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TTTimer : NSObject {

	BOOL _isRunning;
	NSDate *_savedTime;

}

- (void)start;
- (void)stop;
- (BOOL)isRunning;
- (NSDate *)time;

@end
