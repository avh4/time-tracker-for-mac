//
//  TWorkPeriod.m
//  Time Tracker
//
//  Created by Ivan Dramaliev on 10/18/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "TWorkPeriod.h"


@implementation TWorkPeriod

- (id) init
{
	_startTime = nil;
	_endTime = nil;
	_comment = [[NSAttributedString alloc] init];
	return self;
}

- (void) setStartTime: (NSDate *) startTime
{
	[startTime retain];
	[_startTime release];
    _startTime = nil;
	_startTime = startTime;
	[self updateTotalTime];
}

- (void) setEndTime: (NSDate *) endTime
{
	[endTime retain];
	[_endTime release];
    _endTime = nil;
	_endTime = endTime;
	[self updateTotalTime];
}

- (void) setComment:(NSAttributedString*) aComment
{
	if (_comment == aComment) {
		return;
	}
	[_comment release];
    _comment = nil;
	_comment = [aComment retain];
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

- (NSAttributedString *) comment
{
	if (_comment != nil) 
		return _comment;
	return [[[NSAttributedString alloc] initWithString:@""] autorelease];
}

- (NSString *) strComment
{
    if (_comment != nil) {
        return [_comment string];
    } 
    return @"";
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    //[super encodeWithCoder:coder];
    if ( [coder allowsKeyedCoding] ) {
        [coder encodeObject:_startTime forKey:@"WPStartTime"];
        [coder encodeObject:_endTime forKey:@"WPEndTime"];
		[coder encodeObject:_comment forKey:@"AttributedComment"];
		
    } else {
        [coder encodeObject:_startTime];
		[coder encodeObject:_endTime];
		// comment not supported here for data file compability reasons.
    }
    return;
}

- (id)initWithCoder:(NSCoder *)coder
{
    //self = [super initWithCoder:coder];
    if ( [coder allowsKeyedCoding] ) {
        // Can decode keys in any order
        [self setStartTime:[coder decodeObjectForKey:@"WPStartTime"]];
//        _startTime = [[coder decodeObjectForKey:@"WPStartTime"] retain];
        [self setEndTime:[coder decodeObjectForKey:@"WPEndTime"]];
//        _endTime = [[coder decodeObjectForKey:@"WPEndTime"] retain];
		id attribComment = [coder decodeObjectForKey:@"AttributedComment"];
		
		if ([attribComment isKindOfClass:[NSString class]]) {
			attribComment = [[NSAttributedString alloc] initWithString:attribComment];
		}
		if (attribComment == nil) {
			attribComment = [[NSAttributedString alloc] initWithString:[coder decodeObjectForKey:@"Comment"]];
		}
        [self setComment:attribComment];
//		_comment = attribComment;
    } else {
        // Must decode keys in same order as encodeWithCoder:
        [self setStartTime:[coder decodeObject]];
//        _startTime = [[coder decodeObject] retain];
        [self setEndTime:[coder decodeObject]];
//        _endTime = [[coder decodeObject] retain];
		// comment not supported here for data file compability reasons.
    }
	[self updateTotalTime];
    return self;
}

- (NSString*)serializeData:(NSString*) prefix separator:(NSString*)sep
{
	int hours = _totalTime / 3600;
	int minutes = _totalTime % 3600 / 60;
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] initWithDateFormat:@"%Y-%m-%d %H:%M" allowNaturalLanguage:NO]  autorelease];
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] initWithDateFormat:@"%Y-%m-%d" allowNaturalLanguage:NO]  autorelease];
	NSString* result = [NSString stringWithFormat:@"%@%@\"%@\"%@\"%@\"%@\"%@\"%@\"%02d:%02d\"%@\"%@\"\n", prefix, sep, 
		[dateFormatter stringFromDate:_startTime], sep,
		[formatter stringFromDate:_startTime], sep, [formatter stringFromDate:_endTime], sep,
		hours, minutes, sep, [self strComment]];
	return result;
}

- (void)setParentTask:(TTask*) task 
{
	[_parent release];
	_parent = nil;
	_parent = [task retain];
}

- (TTask*)parentTask 
{
	return _parent;
}
@end
