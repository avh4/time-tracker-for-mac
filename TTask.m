//
//  TTask.m
//  Time Tracker
//
//  Created by Ivan Dramaliev on 10/18/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "TTask.h"


@implementation TTask

- (id)init
{
	[self setName: @"New Task"];
	workPeriods = [[NSMutableSet alloc] init];
	return self;
}

- (void)dealloc
{
	[workPeriods release];
	[super dealloc];
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
	NSEnumerator * e = [workPeriods objectEnumerator];
	TWorkPeriod *wp;
	while ((wp = [e nextObject])) {
		totalTime += [wp totalTime];
	}
	return totalTime;
}

- (TProject*)parentProject
{
	return parentProject;
}

- (void)setParentProject:(TProject*)aParentProject
{
	if (parentProject != aParentProject) {
		[parentProject release];
		parentProject = [aParentProject retain];
	}
}

- (NSSet *)workPeriods
{
	return workPeriods;
}

- (void)setWorkPeriods:(NSSet *)newWorkPeriods
{
	if (workPeriods != newWorkPeriods) {
		[workPeriods autorelease];
		workPeriods = [newWorkPeriods mutableCopy];
	}
}

- (void)addWorkPeriodsObject:(TWorkPeriod *)aWorkPeriod
{
	[workPeriods addObject:aWorkPeriod];
}

- (void)addWorkPeriods:(NSSet *)workPeriodsToAdd
{
	[workPeriods unionSet:workPeriodsToAdd];
}

- (void)removeWorkPeriodsObject:(TWorkPeriod *)aWorkPeriod
{
	[workPeriods removeObject:aWorkPeriod];
}

- (void)removeWorkPeriods:(NSSet *)workPeriodsToRemove
{
	[workPeriods minusSet:workPeriodsToRemove];
}

- (void)intersectWorkPeriods:(NSSet *)workPeriodsToIntersect
{
	[workPeriods intersectSet:workPeriodsToIntersect];
}

- (NSMutableArray *) matchingWorkPeriods:(NSPredicate*) filter
{
	NSMutableArray* result = [[[NSMutableArray alloc] init] autorelease];
	NSEnumerator *enumerator = [workPeriods objectEnumerator];
	id anObject;
 
	while (anObject = [enumerator nextObject])
	{
		if ([filter evaluateWithObject:anObject]) {
			[result addObject:anObject];
		}
	}
	return result;
	
}

- (int) filteredTime:(NSPredicate*) filter
{
	if (filter == nil) {
		return [self totalTime];
	}
	NSEnumerator *enumPeriods = [[self matchingWorkPeriods:filter] objectEnumerator];
	id anObject;
	int result = 0;
 
	while (anObject = [enumPeriods nextObject])
	{
		result += [anObject totalTime];
	}
	return result;

}

- (void)encodeWithCoder:(NSCoder *)coder
{
    //[super encodeWithCoder:coder];
    if ( [coder allowsKeyedCoding] ) {
        [coder encodeObject:name forKey:@"TName"];
        [coder encodeObject:workPeriods forKey:@"TWorkPeriods"];
    } else {
        [coder encodeObject:name];
		[coder encodeObject:workPeriods];
    }
    return;
}

- (id)initWithCoder:(NSCoder *)coder
{
    //self = [super initWithCoder:coder];
    if ( [coder allowsKeyedCoding] ) {
        // Can decode keys in any order
        name = [[coder decodeObjectForKey:@"TName"] retain];
		id workPeriodsArrayOrSet = [coder decodeObjectForKey:@"TWorkPeriods"];
		if ([workPeriodsArrayOrSet isKindOfClass:[NSSet class]]) {
			workPeriods = [(NSSet*)workPeriodsArrayOrSet mutableCopy];
		} else if ([workPeriodsArrayOrSet isKindOfClass:[NSArray class]]) {
			workPeriods = [[NSMutableSet alloc] initWithArray:workPeriodsArrayOrSet];
		}
    } else {
        // Must decode keys in same order as encodeWithCoder:
        name = [[coder decodeObject] retain];
        workPeriods = [[NSMutableArray arrayWithArray: [coder decodeObject]] retain];
    }
	// update back links
	NSEnumerator *enumerator = [workPeriods objectEnumerator];
	id anObject;
	while (anObject = [enumerator nextObject])
	{
		[anObject setParentTask:self];
	}

    return self;
}

- (NSString*)serializeData:(NSString*) prefix
{
	NSMutableString* result = [NSMutableString string];
	NSEnumerator *enumerator = [workPeriods objectEnumerator];
	id anObject;
	NSString *addPrefix = [NSString stringWithFormat:@"%@;\"%@\"", prefix, name];
 
	while (anObject = [enumerator nextObject])
	{
		[result appendString:[anObject serializeData:addPrefix]];
	}
	return result;
}

@end
