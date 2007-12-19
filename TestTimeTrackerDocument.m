//
//  TestTimeTrackerDocument.m
//  Time Tracker
//
//  Created by Aaron VonderHaar on 2007-12-07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "TestTimeTrackerDocument.h"


@implementation TestTimeTrackerDocument

- (void) setUp
{
	doc = [[TimeTrackerDocument alloc] init];
}

- (void) testBlankDocumentCsvExport
{
	NSData *expected = [@"\
Date,Start time,End time,Duration,Project,Task\n"
		dataUsingEncoding:NSASCIIStringEncoding];

	NSError *err = nil;
	NSData *data = [doc dataOfType:@"CSV" error:&err];
	STAssertEquals([expected length], [data length], nil);
	STAssertEqualObjects(expected, data, nil);
	STAssertNil(err, nil);
}

- (void) testSimpleDocumentCsvExport
{
	NSData *expected = [@"\
Date,Start time,End time,Duration,Project,Task\n\
2007-01-03,16:00:00,16:15:00,900,New Project,New Task\n"
		dataUsingEncoding:NSASCIIStringEncoding];
	
	NSDate *d1 = [NSDate dateWithString:@"2007-01-03 16:00:00"];
	NSDate *d2 = [NSDate dateWithString:@"2007-01-03 16:15:00"];
	TProject *p = [doc createProject:@"New Project"];
	TTask *t = [doc createTask:@"New Task" inProject:p];
	[doc createWorkPeriodInTask:t from:d1 to:d2];
		
	NSError *err = nil;
	NSData *data = [doc dataOfType:@"CSV" error:&err];
	STAssertEquals([expected length], [data length], nil);
	STAssertEqualObjects(expected, data, nil);
	STAssertNil(err, nil);
}

- (void) tearDown
{
	[doc release];
	doc = nil;
}

@end
