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
	if (workPeriod == nil) return;
	
	assert(dpStartTime != nil);
	assert(dpEndTime != nil);
	[workPeriod setStartTime:[dpStartTime dateValue]];
	[workPeriod setEndTime:[dpEndTime dateValue]];
}

#pragma mark protected methods

- (void)setDpStartTime:(NSDatePicker *)dp
{
	[dpStartTime release];
	dpStartTime = [dp retain];
}

- (void)setDpEndTime:(NSDatePicker *)dp
{
	[dpEndTime release];
	dpEndTime = [dp retain];
}

/**
 * This method bypasses the business logic of the normal setWorkPeriod (above),
 * and is intended for use in setting up unit tests.
 */
- (void)_setWorkPeriod:(TWorkPeriod *)wp
{
	[workPeriod release];
	workPeriod = [wp retain];
}

@end
