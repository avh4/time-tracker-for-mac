//
//  TTDocumentWindowToolbarDelegateTest.m
//  Time Tracker
//
//  Created by Aaron VonderHaar on 4/4/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TTDocumentWindowToolbarDelegateTest.h"


@implementation TTDocumentWindowToolbarDelegateTest

- (void)setUp
{
	// XXX factor out @"TimeTrackerToolbar" to a constant in the delegate
	toolbar = [[NSToolbar alloc] initWithIdentifier: @"TimeTrackerToolbar"];
}

- (void)tearDown
{
	[toolbar release];
	[delegate release];
}

- (void)testItShouldProvideTheDefaultToolbar
{
	// (Start/Stop) (Separator) (New Project) (New Task)
}

- (void)testItShouldProvideTheAvailableToolbarItems
{
	NSArray *allowedIdentifiers;
	allowedIdentifiers = [delegate toolbarAllowedItemIdentifiers:toolbar];
	STAssertTrue([allowedIdentifiers containsObject:@"Start/Stop"], @"", nil);
	STAssertTrue([allowedIdentifiers containsObject:@"New Project"], @"", nil);
	STAssertTrue([allowedIdentifiers containsObject:@"New Task"], @"", nil);
}

- (void)testItShouldProvideTheStartStopItem
{
}

- (void)testItShouldProvideTheNewProjectItem
{
}

- (void)testItShouldProvideTheNewTaskItem
{
}

@end
