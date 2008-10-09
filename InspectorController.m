//
//  InspectorController.m
//  Time Tracker
//
//  Created by Aaron VonderHaar on 10/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "InspectorController.h"


@implementation InspectorController

- (void)dealloc
{
	[workPeriod release];
	[dpStartTime release];
	[dpEndTime release];
	[super dealloc];
}

#pragma mark controller methods

- (void)setWorkPeriod:(TWorkPeriod *)wp
{
	[workPeriod release];
	workPeriod = [wp retain];
	if (workPeriod != nil)
	{
		[dpStartTime setDateValue:[workPeriod startTime]];
		[dpEndTime setDateValue:[workPeriod endTime]];
	}
	else
	{
		[dpStartTime setEnabled:NO];
		[dpEndTime setEnabled:NO];
	}
}

#pragma mark view methods

- (void)workPeriodChanged:(id)sender
{
	;
}

#pragma mark protected methods

- (void)setDpStartTime:(NSDatePicker *)dp
{
	dpStartTime = [dp retain];
}

- (void)setDpEndTime:(NSDatePicker *)dp
{
	dpEndTime = [dp retain];
}

@end
