//
//  TestTWorkPeriod.m
//  Time Tracker
//
//  Created by Aaron VonderHaar on 2007-11-29.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "TestTWorkPeriod.h"
#import "TWorkPeriod.h"


@implementation TestTWorkPeriod

- (void) setUp
{
	t0 = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
	t5s = [NSDate dateWithTimeIntervalSinceReferenceDate:5];
	t1m = [NSDate dateWithTimeIntervalSinceReferenceDate:60];
	t1h1m1s = [NSDate dateWithTimeIntervalSinceReferenceDate:60*60+60+1];
	t5m2hs = [NSDate dateWithTimeIntervalSinceReferenceDate:60*5+2.5];
}

- (void) testTotalTime
{
	TWorkPeriod *wp;
	
	wp = [[TWorkPeriod alloc] init];
	[wp setStartTime:t0];
	[wp setEndTime:t5s];
	STAssertEquals([wp totalTime], 5, @"total time 5s");

	[wp setEndTime:t1m];
	STAssertEquals([wp totalTime], 60, @"total time 1m");

	[wp setEndTime:t1h1m1s];
	STAssertEquals([wp totalTime], 61*60+1, @"total time 1h1m1s");
	
	// total is rounded down to seconds
	[wp setEndTime:t5m2hs];
	STAssertEquals([wp totalTime], 5*60+2, @"total time 5m2.5s");	
}

@end
