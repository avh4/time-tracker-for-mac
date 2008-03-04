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
	startTime = nil;
	endTime = nil;
	comment = [[NSAttributedString alloc] init];
	return self;
}

- (NSDate *)startTime
{
	return startTime;
}

- (void)setStartTime:(NSDate *)aStartTime
{
	if (startTime != aStartTime) {
		[startTime release];
		startTime = [aStartTime copy];
	}
}

- (NSDate *)endTime
{
	return endTime;
}

- (void)setEndTime:(NSDate *)anEndTime
{
	if (endTime != anEndTime) {
		[endTime release];
		endTime = [anEndTime copy];
	}
}

- (NSAttributedString *)comment
{
	return comment;
}

- (void) setComment:(NSAttributedString*) aComment
{
	if (comment != aComment) {
		[comment release];
		comment = [aComment copy];
	}
}

- (int) totalTime
{
	if (endTime == nil || startTime == nil) {
		return 0;
	}
	
	double timeInterval = [endTime timeIntervalSinceDate: startTime];
	return (int) timeInterval;
}

- (TTask *)parentTask 
{
	return parentTask;
}

- (void)setParentTask:(TTask *)aParentTask 
{
	if (parentTask != aParentTask) {
		[parentTask release];
		parentTask = [aParentTask retain];
	}
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    //[super encodeWithCoder:coder];
    if ( [coder allowsKeyedCoding] ) {
        [coder encodeObject:startTime forKey:@"WPStartTime"];
        [coder encodeObject:endTime forKey:@"WPEndTime"];
		[coder encodeObject:comment forKey:@"AttributedComment"];
		
    } else {
        [coder encodeObject:startTime];
		[coder encodeObject:endTime];
		// comment not supported here for data file compability reasons.
    }
    return;
}

- (id)initWithCoder:(NSCoder *)coder
{
    //self = [super initWithCoder:coder];
    if ( [coder allowsKeyedCoding] ) {
        // Can decode keys in any order
        startTime = [[coder decodeObjectForKey:@"WPStartTime"] retain];
        endTime = [[coder decodeObjectForKey:@"WPEndTime"] retain];
		id attribComment = [[coder decodeObjectForKey:@"AttributedComment"] retain];
		
		if ([attribComment isKindOfClass:[NSString class]]) {
			attribComment = [[NSAttributedString alloc] initWithString:attribComment];
		}
		if (attribComment == nil) {
			attribComment = [[NSAttributedString alloc] initWithString:[coder decodeObjectForKey:@"Comment"]];
		}
		comment = attribComment;
    } else {
        // Must decode keys in same order as encodeWithCoder:
        startTime = [[coder decodeObject] retain];
        endTime = [[coder decodeObject] retain];
		// comment not supported here for data file compability reasons.
    }
    return self;
}

- (NSString*)serializeData:(NSString*) prefix
{
	int totalTime = [self totalTime];
	int hours = totalTime / 3600;
	int minutes = totalTime % 3600 / 60;
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] initWithDateFormat:@"%Y-%m-%d %H:%M" allowNaturalLanguage:NO]  autorelease];
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] initWithDateFormat:@"%Y-%m-%d" allowNaturalLanguage:NO]  autorelease];
	NSString* result = [NSString stringWithFormat:@"%@;\"%@\";\"%@\";\"%@\";\"%02d:%02d\";\"%@\"\n", prefix, 
		[dateFormatter stringFromDate:startTime],
		[formatter stringFromDate:startTime], [formatter stringFromDate:endTime], 
		hours, minutes, [self comment]];
	return result;
}

@end
