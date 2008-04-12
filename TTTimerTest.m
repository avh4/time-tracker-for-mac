//
//  TTTimerTest.m
//  Time Tracker
//
//  Created by Aaron VonderHaar on 4/12/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TTTimerTest.h"


@implementation TTTimerTest

- (void)setUp
{
	timer = [[TTTimer alloc] init];
}

- (void)tearDown
{
	[timer release];
}

- (void)testItShouldBeRunningWhenCreated
{
	STAssertTrue([timer isRunning], @"", nil);
}

- (void)testItShouldNotBeRunningAfterBeingStopped
{
	[timer stop];
	STAssertFalse([timer isRunning], @"", nil);
}

- (void)testItShouldNotBeRunningAfterBeingStoppedAndStarted
{
	[timer stop];
	[timer start];
	STAssertTrue([timer isRunning], @"", nil);
}

- (void)testItShouldNotComplainAboutBeingStartedWhileRunning
{
	assert([timer isRunning]);
	STAssertNoThrow([timer start], @"", nil);
	STAssertTrue([timer isRunning], @"", nil);
}

- (void)testItShouldNotComplainAboutBeingStoppedWhileNotRunning
{
	[timer stop];
	STAssertNoThrow([timer stop], @"", nil);
	STAssertFalse([timer isRunning], @"", nil);
}

- (void)testItShouldReturnTheCurrentTimeWhileRunning
{
	assert([timer isRunning]);
	NSDate *now_time, *timer_time;
	
	int i;
	for (i = 0; i < 5; i++) {
		now_time = [NSDate date];
		timer_time = [timer time];
		STAssertEqualObjects(now_time, timer_time, @"", nil);
	
		[NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
	}
}

- (void)testItShouldReturnTheStopTimeWhileNotRunning
{
	assert([timer isRunning]);
	[NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
	NSDate *stop_time, *timer_time;
	
	stop_time = [NSDate date];
	[timer stop];
	[NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
	timer_time = [timer time];
	
	STAssertEqualObjects(stop_time, timer_time, @"", nil);
}

- (void)testItShouldAllowKvoOfTime
{
	//assert(false);
}

- (void)testItShouldUpdateKvoTimeEverySecond
{
	//assert(false);
}

- (void)testItShouldUpdateKvoWhenStopped
{
	//assert(false);
}

@end
