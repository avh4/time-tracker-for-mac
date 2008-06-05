//
//  TTTimerTest.m
//  Time Tracker
//
//  Created by Aaron VonderHaar on 4/12/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TTTimerTest.h"
#import <OCMock/OCMock.h>


@implementation TTTimerTest

- (void)setUp
{
	timer = [[TTTimer alloc] init];
	mockObserver = [OCMockObject mockForClass:[NSObject class]];
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
	for (i = 0; i < 3; i++) {
		now_time = [NSDate date];
		timer_time = [timer time];
		
		STAssertTrue(fabs([now_time timeIntervalSinceDate:timer_time]) < 0.05, @"%@", timer_time);
	
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

	STAssertTrue(fabs([stop_time timeIntervalSinceDate:timer_time]) < 0.05, @"%@", timer_time);	
}

- (void)testItShouldAllowKvoOfTime
{
	STAssertNoThrow([timer addObserver:mockObserver forKeyPath:@"time" options:nil context:nil], @"", nil);
}

- (void)testItShouldUpdateKvoTimeEverySecond
{
	STAssertNoThrow([timer addObserver:mockObserver forKeyPath:@"time" options:nil context:nil], @"", nil);
	
	[[mockObserver expect] observeValueForKeyPath:@"time" ofObject:timer change:[OCMConstraint any] context:nil];
	
	[NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];

	[mockObserver verify];
}

- (void)testItShouldUpdateKvoWhenStopped
{
	STAssertNoThrow([timer addObserver:mockObserver forKeyPath:@"time" options:nil context:nil], @"", nil);
	
	[timer stop];

	STAssertTrue(false, @"PENDING: Need to check that the mock object is called", nil);
}

@end
