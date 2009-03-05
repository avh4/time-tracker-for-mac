//
//  TTask.m
//  Time Tracker
//
//  Created by Ivan Dramaliev on 10/18/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "TTask.h"


@implementation TTask

#define ENCODER_KEY_NAME @"TName"
#define ENCODER_KEY_WORK_PERIODS @"TWorkPeriods"

- (id) init
{
	[self setName:NSLocalizedString(@"New Task", @"Initial name for a newly created task")];
	_workPeriods = [NSMutableArray new];
	return self;
}

- (id)initWithName:(NSString *)name
{
	[self init];
	[self setName:name];
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

- (void) addWorkPeriod: (TWorkPeriod *) workPeriod
{
	[_workPeriods addObject: workPeriod];
}

- (NSMutableArray *) workPeriods
{
	[_workPeriods sortUsingSelector:@selector(compare:)];
	return _workPeriods;
}

- (NSTimeInterval) totalTime
{
	NSTimeInterval _totalTime = 0;
	int i;
	for (i = 0; i < [_workPeriods count]; i++) {
		_totalTime += [[_workPeriods objectAtIndex: i] totalTime];
	}
	return _totalTime;
}

- (NSArray *)workPeriodsInRangeFrom:(NSDate *)from to:(NSDate *)to
{
	NSMutableArray *ret = [NSMutableArray array];
	int i;
	for (i = 0; i < [_workPeriods count]; i++)
	{
		TWorkPeriod *wp = [_workPeriods objectAtIndex:i];
		if ([wp totalTimeInRangeFrom:from to:to] > 0)
		{
			[ret addObject:wp];
		}
	}
	return ret;
}

- (NSTimeInterval)totalTimeInRangeFrom:(NSDate *)from to:(NSDate *)to
{
	NSTimeInterval ret = 0;
	int i;
	for (i = 0; i < [_workPeriods count]; i++)
	{
		TWorkPeriod *wp = [_workPeriods objectAtIndex:i];
		ret += [wp totalTimeInRangeFrom:from to:to];
	}
	return ret;
}



- (void)encodeWithCoder:(NSCoder *)coder
{
    //[super encodeWithCoder:coder];
    if ( [coder allowsKeyedCoding] ) {
        [coder encodeObject:_name forKey:ENCODER_KEY_NAME];
        [coder encodeObject:_workPeriods forKey:ENCODER_KEY_WORK_PERIODS];
    } else {
        [coder encodeObject:_name];
		[coder encodeObject:_workPeriods];
    }
    return;
}

- (id)initWithCoder:(NSCoder *)coder
{
    //self = [super initWithCoder:coder];
    if ( [coder allowsKeyedCoding] ) {
        // Can decode keys in any order
        _name = [[coder decodeObjectForKey:ENCODER_KEY_NAME] retain];
        _workPeriods = [[NSMutableArray arrayWithArray: [coder decodeObjectForKey:ENCODER_KEY_WORK_PERIODS]] retain];
    } else {
        // Must decode keys in same order as encodeWithCoder:
        _name = [[coder decodeObject] retain];
        _workPeriods = [[NSMutableArray arrayWithArray: [coder decodeObject]] retain];
    }
    return self;
}

@end
