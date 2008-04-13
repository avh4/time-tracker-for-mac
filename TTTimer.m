//
//  TTTimer.m
//  Time Tracker
//
//  Created by Aaron VonderHaar on 4/12/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TTTimer.h"


@implementation TTTimer

- (id)init
{
	[super init];
	[self start];
	return self;
}

- (void)start
{
	_isRunning = YES;
	if (_savedTime == nil) {
		_savedTime = [NSDate alloc];
	}
	[_savedTime init];
}

- (void)stop
{
	_isRunning = NO;
	[_savedTime init];
}

- (BOOL)isRunning
{
	return _isRunning;
}

- (NSDate *)time
{
	if (_isRunning) {
		[_savedTime init];
	}
	return [[_savedTime copy] autorelease];
}

@end
