//
//  TWorkPeriod.h
//  Time Tracker
//
//  Created by Ivan Dramaliev on 10/18/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//forward declaration
@class TTask;

@interface TWorkPeriod : NSObject <NSCoding> {
	// Attributes
	NSDate *startTime;
	NSDate *endTime;
	NSAttributedString* comment;

	// Relationships
	TTask *parentTask;
	
}

// Mutable Attributes

- (NSDate *) startTime;
- (void) setStartTime: (NSDate *) startTime;

- (NSDate *) endTime;
- (void) setEndTime: (NSDate *) endTime;

- (NSAttributedString *) comment;
- (void) setComment:(NSAttributedString*) aComment;

// Immutable Attributes

- (int) totalTime;

// To-one Relationships

- (TTask*) parentTask;
- (void) setParentTask:(TTask*) task;

// Other functions

- (NSString*) serializeData: (NSString*) prefix;
@end
