//
//  TTDocumentWindowToolbarDelegateTest.m
//  Time Tracker
//
//  Created by Aaron VonderHaar on 4/4/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TTDocumentWindowToolbarDelegateTest.h"
#import "TTDocumentWindowController.h"


@implementation TTDocumentWindowToolbarDelegateTest

- (void)setUp
{
	delegate = [[TTDocumentWindowController alloc] init];
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
	// Time Tracker toolbar items
	STAssertTrue([allowedIdentifiers containsObject:TTDocumentStartStopItemIdentifier], @"", nil);
	STAssertTrue([allowedIdentifiers containsObject:TTDocumentNewProjectItemIdentifier], @"", nil);
	STAssertTrue([allowedIdentifiers containsObject:TTDocumentNewTaskItemIdentifier], @"", nil);
	// Default toolbar items
	STAssertTrue([allowedIdentifiers containsObject:NSToolbarPrintItemIdentifier], @"", nil);
	STAssertTrue([allowedIdentifiers containsObject:NSToolbarCustomizeToolbarItemIdentifier], @"", nil);
	STAssertTrue([allowedIdentifiers containsObject:NSToolbarFlexibleSpaceItemIdentifier], @"", nil);
	STAssertTrue([allowedIdentifiers containsObject:NSToolbarSpaceItemIdentifier], @"", nil);
	STAssertTrue([allowedIdentifiers containsObject:NSToolbarSeparatorItemIdentifier], @"", nil);
	// Check that the toolbar items list ends with nil
	STAssertNil([allowedIdentifiers lastObject], @"", nil);
}

- (void)testItShouldProvideTheStartStopItem
{
	NSToolbarItem *startStopItem;
	startStopItem = [delegate toolbar:toolbar itemForItemIdentifier:TTDocumentStartStopItemIdentifier willBeInsertedIntoToolbar:YES];
	STAssertNotNil(startStopItem, @"", nil);
}

- (void)testItShouldProvideTheNewProjectItem
{
	NSToolbarItem *newProjectItem;
	newProjectItem = [delegate toolbar:toolbar itemForItemIdentifier:TTDocumentNewProjectItemIdentifier willBeInsertedIntoToolbar:YES];
	STAssertNotNil(newProjectItem, @"", nil);
}

- (void)testItShouldProvideTheNewTaskItem
{
	NSToolbarItem *newTaskItem;
	newTaskItem = [delegate toolbar:toolbar itemForItemIdentifier:TTDocumentNewTaskItemIdentifier willBeInsertedIntoToolbar:YES];
	STAssertNotNil(newTaskItem, @"", nil);
}

@end
