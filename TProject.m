//
//  TProject.m
//  Time Tracker
//
//  Created by Ivan Dramaliev on 10/18/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "TProject.h"


@implementation TProject

- (id) init
{
	[self setName: @"New Project"];
	tasks = [NSMutableSet new];
	return self;
}

- (NSString *)name
{
	return name;
}

- (void)setName:(NSString *)aName
{
	if (name != aName) {
		[name release];
		name = [aName copy];
	}
}

- (int) totalTime
{
	int totalTime = 0;
	NSEnumerator *e = [tasks objectEnumerator];
	TTask *t;
	while ((t = [e nextObject])) {
		totalTime += [t totalTime];
	}
	return totalTime;
}

- (NSSet *)tasks
{
	return tasks;
}

- (void)setTasks:(NSSet *)newTasks
{
	if (tasks != newTasks) {
		[tasks release];
		tasks = [newTasks mutableCopy];
	}
}

- (void)addTasksObject:(TTask *)aTask
{
	[tasks addObject:aTask];
}

- (void)addTasks:(NSSet *)tasksToAdd
{
	[tasks unionSet:tasksToAdd];
}

- (void)removeTasksObject:(TTask *)aTask
{
	[tasks removeObject:aTask];
}

- (void)removeTasks:(NSSet *)tasksToRemove
{
	[tasks minusSet:tasksToRemove];
}

- (void)intersectTasks:(NSSet *)tasksToIntersect
{
	[tasks intersectSet:tasksToIntersect];
}


- (NSMutableArray *) matchingTasks:(NSPredicate*) filter
{
	NSMutableArray *result = [[[NSMutableArray alloc] init] autorelease];
	// this needs to be performance tuned but it does the job for now
	NSEnumerator *enumTasks = [tasks objectEnumerator];
	id task;
	while ((task = [enumTasks nextObject]) != nil) {
		if ([[task matchingWorkPeriods:filter] count] > 0) {
			[result addObject:task];
		}
	}
	return result;
}

- (int) filteredTime:(NSPredicate*) filter
{
	if (filter == nil) {
		return [self totalTime];
	}
	int result = 0;
	NSEnumerator *enumTasks = [tasks objectEnumerator];
	id task;
	while ((task = [enumTasks nextObject]) != nil) {
		result += [task filteredTime:filter];
	}
	return result;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    //[super encodeWithCoder:coder];
    if ( [coder allowsKeyedCoding] ) {
        [coder encodeObject:name forKey:@"PName"];
        [coder encodeObject:tasks forKey:@"PTasks"];
    } else {
        [coder encodeObject:name];
		[coder encodeObject:tasks];
    }
    return;
}

- (id)initWithCoder:(NSCoder *)coder
{
    //self = [super initWithCoder:coder];
    if ( [coder allowsKeyedCoding] ) {
        // Can decode keys in any order
        name = [[coder decodeObjectForKey:@"PName"] retain];
        tasks = [[NSMutableArray arrayWithArray: [coder decodeObjectForKey:@"PTasks"]] retain];
    } else {
        // Must decode keys in same order as encodeWithCoder:
        name = [[coder decodeObject] retain];
        tasks = [[NSMutableArray arrayWithArray: [coder decodeObject]] retain];
    }
	
		// update back links
	NSEnumerator *enumerator = [tasks objectEnumerator];
	id anObject;
	while (anObject = [enumerator nextObject])
	{
		[anObject setParentProject:self];
	}

    return self;
}

- (NSString*)serializeData
{
	NSMutableString* result = [NSMutableString string];
	NSEnumerator *enumerator = [tasks objectEnumerator];
	id anObject;
	NSString *prefix = [NSString stringWithFormat:@"\"%@\"", name];
	while (anObject = [enumerator nextObject])
	{
		[result appendString:[anObject serializeData:prefix]];
	}
	return [[result retain] autorelease];
}

@end
