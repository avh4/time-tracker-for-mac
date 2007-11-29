//
//  TMetaTask.m
//  Time Tracker
//
//  Created by Rainer Burgstaller on 26.11.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "TMetaTask.h"
#import "TTask.h"

@implementation TMetaTask
- (NSString *) name {
	return @"All Tasks";
}

- (NSMutableArray *) workPeriods {
	NSEnumerator *enumTasks = [_tasks objectEnumerator];
	TTask *task = nil;
	NSMutableArray *result = [[[NSMutableArray alloc] init] autorelease];
	while ((task = [enumTasks nextObject]) != nil) {
		[result addObjectsFromArray:[task workPeriods]];
	}
	return result;
}

- (int) totalTime {
	NSEnumerator *enumTasks = [_tasks objectEnumerator];
	TTask *task = nil;
	int result = 0;
	while ((task = [enumTasks nextObject]) != nil) {
		result += [task totalTime];
	}
	return result;
}

- (void) updateTotalTime {
	NSEnumerator *enumTasks = [_tasks objectEnumerator];
	TTask *task = nil;
	
	while ((task = [enumTasks nextObject]) != nil) {
		[task updateTotalTime];
	}
}
- (void) setTasks:(NSArray*)tasks {
	[_tasks release];
	_tasks = [tasks retain];
}


- (TTask*) taskForWorkPeriod:(TWorkPeriod*)aPeriod returnIndex:(int*)wpIndex {
	NSEnumerator *enumerator = [_tasks objectEnumerator];
	id aTask;
	*wpIndex = -1;
	
	while (aTask = [enumerator nextObject])
	{
		unsigned result = [[aTask workPeriods] indexOfObject:aPeriod];
		if (result != NSNotFound) {
			*wpIndex = result;
			return aTask;
		}
	}
	*wpIndex = -1;
	return nil;
}

- (id<ITask>) removeWorkPeriod:(TWorkPeriod*)period {
	int index = -1;
	TTask *task = [self taskForWorkPeriod:period returnIndex:&index];
	[[task workPeriods] removeObject:period];
	return self;
}


@end
