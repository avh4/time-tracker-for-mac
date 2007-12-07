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

- (void) testInstance
{
	STAssertNotNil([doc projects], nil);
}

- (void) tearDown
{
	[doc release];
	doc = nil;
}

@end
