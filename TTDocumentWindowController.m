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

@end
