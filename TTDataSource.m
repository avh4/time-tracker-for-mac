//
//  TTDataSource.m
//  Time Tracker
//
//  Created by Aaron VonderHaar on 7/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TTDataSource.h"
#import "TWorkPeriod.h"
#import "TimeIntervalFormatter.h"
#import "TimeIntervalFormatter.m"
#import "TTDocument.h"


@implementation TTDataSource

- (void) setWorkPeriods: (NSArray *) wp
{
	[workPeriods release];
	workPeriods = [wp retain];
}

- (void) setDocument:(TTDocument *)doc
{
	[document release];
	document = [doc retain];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)rowIndex
{
	if ([[tableColumn identifier] isEqualToString: @"Date"]) {
		return [[[workPeriods objectAtIndex: rowIndex] startTime] 
			descriptionWithCalendarFormat: @"%m/%d/%Y"
			timeZone: nil locale: nil];
	}
	if ([[tableColumn identifier] isEqualToString: @"StartTime"]) {
		return [[[workPeriods objectAtIndex: rowIndex] startTime] 
			descriptionWithCalendarFormat: @"%H:%M:%S"
			timeZone: nil locale: nil];
	}
	if ([[tableColumn identifier] isEqualToString: @"EndTime"]) {
		NSDate *endTime = [[workPeriods objectAtIndex: rowIndex] endTime];
		if (endTime == nil)
			return @"";
		else
			return [endTime 
				descriptionWithCalendarFormat: @"%H:%M:%S"
				timeZone: nil locale: nil];
	}
	if ([[tableColumn identifier] isEqualToString: @"Duration"]) {
		return [TimeIntervalFormatter secondsToString: [[workPeriods objectAtIndex: rowIndex] totalTime]];
	}
	return nil;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
	if (item == nil)
	{
		return [[document projects] count];
	}
	if ([item isKindOfClass:[TProject class]])
	{
		return [[item tasks] count];
	}
	return 0;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
	if (item == nil)
	{
		return [[document projects] objectAtIndex:index];
	}
	if ([item isKindOfClass:[TProject class]])
	{
		return [[item tasks] objectAtIndex:index];
	}
	return nil;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
	if (item == nil)
	{
		return true;
	}
	if ([item isKindOfClass:[TProject class]])
	{
		return true;
	}
	return false;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
	if ([[tableColumn identifier] isEqualToString:@"ProjectName"])
	{
		if ([item isKindOfClass:[TProject class]])
		{
			return [item name];
		}
		return nil;
	}
	if ([[tableColumn identifier] isEqualToString:@"TotalTime"])
	{
		if ([item isKindOfClass:[TProject class]])
		{
			return [TimeIntervalFormatter secondsToString: [item totalTime]];
		}
		return nil;
	}
	return nil;
}

@end

// This initialization function gets called when we import the Ruby module.
// It doesn't need to do anything because the RubyCocoa bridge will do
// all the initialization work.
// The rbiphonetest test framework automatically generates bundles for 
// each objective-c class containing the following line. These
// can be used by your tests.
void Init_TTDataSource() { }