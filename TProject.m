//
//  TProject.m
//  Time Tracker
//
//  Created by Ivan Dramaliev on 10/18/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "TProject.h"


@implementation TProject

#define ENCODER_KEY_NAME @"PName"
#define ENCODER_KEY_TASKS @"PTasks"

- (id) init
{
	[self setName:NSLocalizedString(@"New Project", @"Initial name for a newly created project")];
	_tasks = [NSMutableArray new];
	return self;
}

- (NSString *) name
{
	return _name;
}

- (void) setName: (NSString *) name
{
	[name retain];
	[_name release];
	_name = name;
}

- (NSMutableArray *) tasks
{
	return _tasks;
}

- (void) addTask: (TTask *) task
{
	[_tasks addObject: task];
}

- (id)objectInTasksAtIndex:(int)index
{
	return [_tasks objectAtIndex:index];
}

- (void)moveTask:(TTask *)task toIndex:(int)index
{
	int oldIndex = [_tasks indexOfObject:task];
	if (oldIndex == NSNotFound)
	{
		NSLog(@"TProject moveTask:toIndex: task was not found in the tasks lists");
		return;
	}
	
	[_tasks insertObject:task atIndex:index];
	if (oldIndex >= index) oldIndex++;
	[_tasks removeObjectAtIndex:oldIndex];
}

- (int) totalTime
{
	int _totalTime = 0;
	int i;
	for (i = 0; i < [_tasks count]; i++) {
		_totalTime += [[_tasks objectAtIndex: i] totalTime];
	}
	return _totalTime;
}

- (int)totalTimeInRangeFrom:(NSDate *)from to:(NSDate *)to
{
	int ret = 0;
	int i;
	for (i = 0; i < [_tasks count]; i++)
	{
		TTask *t = [_tasks objectAtIndex:i];		
		ret += [t totalTimeInRangeFrom:from to:to];
	}
	return ret;
}


- (void)encodeWithCoder:(NSCoder *)coder
{
    //[super encodeWithCoder:coder];
    if ( [coder allowsKeyedCoding] ) {
        [coder encodeObject:_name forKey:ENCODER_KEY_NAME];
        [coder encodeObject:_tasks forKey:ENCODER_KEY_TASKS];
    } else {
        [coder encodeObject:_name];
		[coder encodeObject:_tasks];
    }
    return;
}

- (id)initWithCoder:(NSCoder *)coder
{
    //self = [super initWithCoder:coder];
    if ( [coder allowsKeyedCoding] ) {
        // Can decode keys in any order
        _name = [[coder decodeObjectForKey:ENCODER_KEY_NAME] retain];
        _tasks = [[NSMutableArray arrayWithArray: [coder decodeObjectForKey:ENCODER_KEY_TASKS]] retain];
    } else {
        // Must decode keys in same order as encodeWithCoder:
        _name = [[coder decodeObject] retain];
        _tasks = [[NSMutableArray arrayWithArray: [coder decodeObject]] retain];
    }
    return self;
}

@end

// This initialization function gets called when we import the Ruby module.
// It doesn't need to do anything because the RubyCocoa bridge will do
// all the initialization work.
// The rbiphonetest test framework automatically generates bundles for 
// each objective-c class containing the following line. These
// can be used by your tests.
void Init_TProject() { }
