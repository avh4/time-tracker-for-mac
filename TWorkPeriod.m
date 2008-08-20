//
//  TWorkPeriod.m
//  Time Tracker
//
//  Created by Ivan Dramaliev on 10/18/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "TWorkPeriod.h"


@implementation TWorkPeriod

#define ENCODER_KEY_START_TIME @"WPStartTime"
#define ENCODER_KEY_END_TIME @"WPEndTime"

- (id) init
{
	_startTime = [[NSDate alloc] init];
	_endTime = [[NSDate alloc] init];
	return self;
}

- (void) setStartTime: (NSDate *) startTime
{
	[startTime retain];
	[_startTime release];
	_startTime = startTime;
	[self updateTotalTime];
}

- (void) setEndTime: (NSDate *) endTime
{
	[endTime retain];
	[_endTime release];
	_endTime = endTime;
	[self updateTotalTime];
}

- (void) updateTotalTime
{
	if (_endTime == nil || _startTime == nil) {
		_totalTime = 0;
		return;
	}
	double timeInterval = [_endTime timeIntervalSinceDate: _startTime];
	_totalTime = (int) timeInterval;
}

- (int) totalTime
{
	return _totalTime;
}

- (NSDate *) startTime
{
	return _startTime;
}

- (NSDate *) endTime
{
	return _endTime;
}

- (int)totalTimeInRangeFrom:(NSDate *)from to:(NSDate *)to
{
	return _totalTime;
}

- (NSComparisonResult)compare:(TWorkPeriod *)wp
{
	assert( wp != nil );
	assert( [wp startTime] != nil );
	assert( [self startTime] != nil );
	return [[self startTime] compare:[wp startTime]];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    //[super encodeWithCoder:coder];
    if ( [coder allowsKeyedCoding] ) {
        [coder encodeObject:_startTime forKey:ENCODER_KEY_START_TIME];
        [coder encodeObject:_endTime forKey:ENCODER_KEY_END_TIME];
    } else {
        [coder encodeObject:_startTime];
		[coder encodeObject:_endTime];
    }
    return;
}

- (id)initWithCoder:(NSCoder *)coder
{
    //self = [super initWithCoder:coder];
    if ( [coder allowsKeyedCoding] ) {
        // Can decode keys in any order
        _startTime = [[coder decodeObjectForKey:ENCODER_KEY_START_TIME] retain];
        _endTime = [[coder decodeObjectForKey:ENCODER_KEY_END_TIME] retain];
    } else {
        // Must decode keys in same order as encodeWithCoder:
        _startTime = [[coder decodeObject] retain];
        _endTime = [[coder decodeObject] retain];
    }
	[self updateTotalTime];
    return self;
}

@end

// This initialization function gets called when we import the Ruby module.
// It doesn't need to do anything because the RubyCocoa bridge will do
// all the initialization work.
// The rbiphonetest test framework automatically generates bundles for 
// each objective-c class containing the following line. These
// can be used by your tests.
void Init_TWorkPeriod() { }
