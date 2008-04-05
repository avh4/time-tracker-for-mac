//
//  TTDocumentWindowToolbarDelegateTest.m
//  Time Tracker
//
//  Created by Aaron VonderHaar on 4/4/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TTDocumentWindowToolbarDelegateTest.h"


@implementation TTDocumentWindowToolbarDelegateTest

// XXX move these to the delegate header
#define TTDocumentToolbarIdentifier @"TimeTrackerToolbar"
#define TTDocumentStartStopItemIdentifier @"Startstop"
#define TTDocumentNewProjectItemIdentifier @"AddProject"
#define TTDocumentNewTaskItemIdentifier @"AddTask"

- (void)setUp
{
	toolbar = [[NSToolbar alloc] initWithIdentifier: TTDocumentToolbarIdentifier];
}

- (void)tearDown
{
	[toolbar release];
	[delegate release];
}

- (void)testItShouldProvideTheDefaultToolbar
{
	NSArray *defaultToolbar;
	defaultToolbar = [delegate toolbarDefaultItemIdentifiers:toolbar];
	STAssertEqualObjects(TTDocumentStartStopItemIdentifier, [defaultToolbar objectAtIndex:0], @"", nil);
	STAssertEqualObjects(NSToolbarSeparatorItemIdentifier, [defaultToolbar objectAtIndex:1], @"", nil);
	STAssertEqualObjects(TTDocumentNewProjectItemIdentifier, [defaultToolbar objectAtIndex:2], @"", nil);
	STAssertEqualObjects(TTDocumentNewTaskItemIdentifier, [defaultToolbar objectAtIndex:3], @"", nil);
}

- (void)testItShouldProvideTheAvailableToolbarItems
{
	NSArray *allowedIdentifiers;
	allowedIdentifiers = [delegate toolbarAllowedItemIdentifiers:toolbar];
	STAssertTrue([allowedIdentifiers containsObject:TTDocumentStartStopItemIdentifier], @"", nil);
	STAssertTrue([allowedIdentifiers containsObject:TTDocumentNewProjectItemIdentifier], @"", nil);
	STAssertTrue([allowedIdentifiers containsObject:TTDocumentNewTaskItemIdentifier], @"", nil);
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
