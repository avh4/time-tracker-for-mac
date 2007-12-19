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
	NSData *expected = [
		@"Date,Start time,End time,Duration,Project,Task\n"
		dataUsingEncoding:NSASCIIStringEncoding];
	NSError *err = nil;
	NSData *data = [doc dataOfType:@"CSV" error:&err];
	// STFail(@"%@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
	STAssertEqualObjects(expected, data, nil);
	STAssertNil(err, nil);
}

- (void) tearDown
{
	[doc release];
	doc = nil;
}

@end
