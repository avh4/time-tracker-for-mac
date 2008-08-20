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

- (int) totalTime
{
	int _totalTime = 0;
	int i;
	for (i = 0; i < [_workPeriods count]; i++) {
		_totalTime += [[_workPeriods objectAtIndex: i] totalTime];
	}
	return _totalTime;
}

- (NSArray *)workPeriodsInRangeFrom:(NSDate *)from to:(NSDate *)to
{
	return nil;
}

- (int)totalTimeInRangeFrom:(NSDate *)from to:(NSDate *)to
{
	return 0;
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

// This initialization function gets called when we import the Ruby module.
// It doesn't need to do anything because the RubyCocoa bridge will do
// all the initialization work.
// The rbiphonetest test framework automatically generates bundles for 
// each objective-c class containing the following line. These
// can be used by your tests.
void Init_TTask() { }
