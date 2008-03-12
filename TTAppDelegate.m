//
//  TTAppDelegate.m
//  Time Tracker
//
//  Created by Aaron VonderHaar on 3/11/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TTAppDelegate.h"
#import "TimeTrackerDocument.h"


@implementation TTAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Create the NSDocumentController and cause it to load the singleton
	// Time Tracker Document.

	NSDocumentController *docC = [NSDocumentController sharedDocumentController];
	NSString *docPath = [@"~/Library/Application Support/TimeTracker/data.plist" stringByExpandingTildeInPath];
	NSURL *docURL = [NSURL fileURLWithPath:docPath];

	assert([docC documentForURL:docURL] == nil);
	
	NSError *outError = nil;

	TimeTrackerDocument *doc = 
		[docC makeDocumentWithContentsOfURL:docURL ofType:TT_V2_TYPE error:&outError];
	
	if (doc == nil) {
		NSLog(@"Failed to open default document: %@", [outError localizedDescription] );
		[[NSApplication sharedApplication] terminate:self];
	}
	
	[docC addDocument:doc];
	[doc makeWindowControllers];
	[doc showWindows];
}

@end
