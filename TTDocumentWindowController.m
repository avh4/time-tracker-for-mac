//
//  TTDocumentWindowController.m
//  Time Tracker
//
//  Created by Aaron VonderHaar on 3/28/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TTDocumentWindowController.h"


@implementation TTDocumentWindowController

- (id)init
{
	[self initWithWindowNibName:@"TimeTrackerMainWindow"];
	return self;
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName
{
	return @"Time Tracker";
}

- (void)awakeFromNib
{
	bundle = [NSBundle mainBundle];

	NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:TTDocumentToolbarIdentifier];
	[toolbar setDelegate:self];
	[[self window] setToolbar:toolbar];	
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar
{
	return [NSArray arrayWithObjects:
		TTDocumentStartStopItemIdentifier,
		TTDocumentNewProjectItemIdentifier,
		TTDocumentNewTaskItemIdentifier,
		NSToolbarPrintItemIdentifier,
		NSToolbarCustomizeToolbarItemIdentifier,
		NSToolbarFlexibleSpaceItemIdentifier,
		NSToolbarSpaceItemIdentifier,
		NSToolbarSeparatorItemIdentifier,
		nil];
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar
{
	return [NSArray arrayWithObjects:
		TTDocumentStartStopItemIdentifier,
		NSToolbarSeparatorItemIdentifier,
		TTDocumentNewProjectItemIdentifier,
		TTDocumentNewTaskItemIdentifier,
		nil];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)item willBeInsertedIntoToolbar:(BOOL)willBeInserted
{
	assert(bundle != nil);

	if ([item isEqualToString:TTDocumentStartStopItemIdentifier]) {
		NSToolbarItem *toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier:TTDocumentStartStopItemIdentifier] autorelease];
		//startstopToolbarItem = toolbarItem;
		[toolbarItem setTarget:self];
		[toolbarItem setAction:@selector(clickedStartStopTimer:)];
		//[self updateStartStopState];
		return toolbarItem;
    }
	
	if ([item isEqualToString:TTDocumentNewProjectItemIdentifier]) {
		NSToolbarItem *toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier:TTDocumentNewProjectItemIdentifier] autorelease];
		[toolbarItem setLabel:@"New project"];
		[toolbarItem setPaletteLabel:@"New project"];
		[toolbarItem setToolTip:@"New project"];
		NSImage *addProjectToolImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"addprojecttool" ofType:@"png"]];
		[toolbarItem setImage: addProjectToolImage];
		[addProjectToolImage release];
		[toolbarItem setTarget:self];
		[toolbarItem setAction:@selector(clickedAddProject:)];
		return toolbarItem;
    }
	
	if ([item isEqualToString:TTDocumentNewTaskItemIdentifier]) {
		NSToolbarItem *toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier:TTDocumentNewTaskItemIdentifier] autorelease];
		[toolbarItem setLabel:@"New task"];
		[toolbarItem setPaletteLabel:@"New task"];
		[toolbarItem setToolTip:@"New task"];
		NSImage	*addTaskToolImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"addtasktool" ofType:@"png"]];
		[toolbarItem setImage: addTaskToolImage];
		[addTaskToolImage release];
		[toolbarItem setTarget:self];
		[toolbarItem setAction:@selector(clickedAddTask:)];
		return toolbarItem;
    }
	return nil;
}

@end
