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
	NSLog(@"TTAppDelegate.applicationDidFinishLaunching:");
	
	NSString *docPath = [@"~/Library/Application Support/TimeTracker/data.plist" stringByExpandingTildeInPath];
	NSURL *docURL = [NSURL fileURLWithPath:docPath];
	NSDocumentController *docC = [NSDocumentController sharedDocumentController];
	NSError *outError = nil;
	TimeTrackerDocument *doc = 
		[docC openDocumentWithContentsOfURL:docURL display:YES error:&outError];
	
	if (doc == nil && outError != nil) {
		NSLog(@"Failed to open default document: %@", [outError localizedDescription] );
		[[NSApplication sharedApplication] terminate:self];
	}
}

@end
