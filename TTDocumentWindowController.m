//
//  TTDocumentWindowController.m
//  Time Tracker
//
//  Created by Aaron VonderHaar on 3/28/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TTDocumentWindowController.h"
#import "TProject.h"


@implementation TTDocumentWindowController

- (id)init
{
	[self initWithWindowNibName:@"TimeTrackerMainWindow"];
	bundle = [NSBundle mainBundle];
	return self;
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName
{
	return @"Time Tracker";
}

- (void)awakeFromNib
{
	assert(projectsController != nil);
	assert(tasksController != nil);

	NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:TTDocumentToolbarIdentifier];
	[toolbar setDelegate:self];
	[[self window] setToolbar:toolbar];	
}

- (void)_updateStartStopState
{
	// Update the toolbar item if it exists
	if (toolbarItemStartStop != nil) {
		
		// Create the toolbar images if they haven't been already
		if (toolbarImageStart == nil) {
			assert(toolbarImageStop == nil);
			toolbarImageStart = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"playtool" ofType:@"png"]];
			toolbarImageStop = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"stoptool" ofType:@"png"]];
		}
		
		if (true) {
			[toolbarItemStartStop setImage:toolbarImageStart];
			[toolbarItemStartStop setLabel:@"Start timer"];
			[toolbarItemStartStop setPaletteLabel:@"Start timer"];
			[toolbarItemStartStop setToolTip:@"Start timer"];
		} else {
			[toolbarItemStartStop setImage:toolbarImageStop];
			[toolbarItemStartStop setLabel:@"Stop timer"];
			[toolbarItemStartStop setPaletteLabel:@"Stop timer"];
			[toolbarItemStartStop setToolTip:@"Stop timer"];
		}
	}
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
		if (toolbarItemStartStop == nil) {
			toolbarItemStartStop = [[[NSToolbarItem alloc] initWithItemIdentifier:TTDocumentStartStopItemIdentifier] autorelease];
			[self _updateStartStopState];
			[toolbarItemStartStop setTarget:nil];
			[toolbarItemStartStop setAction:@selector(toggleIsTimerActive:)];
		}
		return toolbarItemStartStop;
    }
	
	if ([item isEqualToString:TTDocumentNewProjectItemIdentifier]) {
		NSToolbarItem *toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier:TTDocumentNewProjectItemIdentifier] autorelease];
		[toolbarItem setLabel:@"New project"];
		[toolbarItem setPaletteLabel:@"New project"];
		[toolbarItem setToolTip:@"New project"];
		NSImage *addProjectToolImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"addprojecttool" ofType:@"png"]];
		[toolbarItem setImage: addProjectToolImage];
		[addProjectToolImage release];
		[toolbarItem setTarget:nil];
		[toolbarItem setAction:@selector(newProject:)];
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
		[toolbarItem setTarget:nil];
		[toolbarItem setAction:@selector(newTask:)];
		return toolbarItem;
    }
	return nil;
}

- (void)newProject:(id)sender
{
	[projectsController insert:sender];
}

- (void)newTask:(id)sender
{
	NSIndexSet *selection = [projectsController selectionIndexes];
	if (selection == nil || [selection count] == 0) {
		
		TProject *newProj = [projectsController newObject];
		[projectsController addObject:newProj];
		[projectsController setSelectedObjects:[NSArray arrayWithObject:newProj]];
		
		[tasksController insert:sender];
		
	} else if ([selection count] == 1) {
		[tasksController insert:sender];
	} else {
		NSLog(@"TTDocumentWindowController.newTask called with project selection %@",
			selection);
		return;
	}
}

@end
