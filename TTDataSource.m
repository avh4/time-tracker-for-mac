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


@implementation TTDataSource

- (void) setWorkPeriods: (NSArray *) wp
{
	[workPeriods release];
	workPeriods = [wp retain];
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

@end
