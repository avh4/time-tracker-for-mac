//
//  TTDurationFormatterTest.m
//  Time Tracker
//
//  Created by Aaron VonderHaar on 4/2/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TTDurationFormatterTest.h"


@implementation TTDurationFormatterTest

- (void)setUp
{
	formatter = [[TTDurationFormatter alloc] init];
}

- (void)tearDown
{
	[formatter release];
}

- (void)testItShouldFormatZero
{
	STAssertEqualObjects(
		@"00:00:00",
		[formatter stringForObjectValue:[NSNumber numberWithInt:0]],
		@"", nil);
}

- (void)testItShouldFormatSeconds
{
	STAssertEqualObjects(
		@"00:00:01",
		[formatter stringForObjectValue:[NSNumber numberWithInt:1]],
		@"", nil);
	STAssertEqualObjects(
		@"00:00:10",
		[formatter stringForObjectValue:[NSNumber numberWithInt:10]],
		@"", nil);
	STAssertEqualObjects(
		@"00:00:59",
		[formatter stringForObjectValue:[NSNumber numberWithInt:59]],
		@"", nil);	
}

- (void)testItShouldFormatMinutes
{
	STAssertEqualObjects(
		@"00:01:01",
		[formatter stringForObjectValue:[NSNumber numberWithInt:61]],
		@"", nil);
	STAssertEqualObjects(
		@"00:10:10",
		[formatter stringForObjectValue:[NSNumber numberWithInt:610]],
		@"", nil);
	STAssertEqualObjects(
		@"00:59:59",
		[formatter stringForObjectValue:[NSNumber numberWithInt:3599]],
		@"", nil);	
}

- (void)testItShouldFormatHours
{
	STAssertEqualObjects(
		@"01:01:01",
		[formatter stringForObjectValue:[NSNumber numberWithInt:(3600+60+1)]],
		@"", nil);
	STAssertEqualObjects(
		@"10:10:10",
		[formatter stringForObjectValue:[NSNumber numberWithInt:(10*3600+10*60+10)]],
		@"", nil);
	STAssertEqualObjects(
		@"100:59:59",
		[formatter stringForObjectValue:[NSNumber numberWithInt:(100*3600+59*60+59)]],
		@"", nil);	
}

- (void)testItShouldReturnSomethingForInvalidObjects
{
	id returnValue;
	STAssertNoThrow(returnValue = [formatter stringForObjectValue:[NSDate date]], @"", nil);
	STAssertTrue([returnValue isKindOfClass:[NSString class]], @"", nil);
}

@end
