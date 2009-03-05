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

- (id)initWithStartTime:(NSDate *)startTime endTime:(NSDate *)endTime
{
	_startTime = [startTime copy];
	_endTime = [endTime copy];
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

- (NSTimeInterval) totalTime
{
	[self updateTotalTime];
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

- (NSTimeInterval)totalTimeInRangeFrom:(NSDate *)from to:(NSDate *)to
{
	NSTimeInterval ret = 0;
	NSDate *start = [self startTime];
	NSDate *end = [self endTime];
	if (start == nil || end == nil) return 0;
	
	if ([start compare:from] == NSOrderedAscending)
	{
		start = from;
	}
	if ([end compare:to] == NSOrderedDescending)
	{
		end = to;
	}
	ret = [end timeIntervalSinceDate: start];
	if (ret < 0) return 0;
	return ret;
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
