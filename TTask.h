//
//  TTask.h
//  Time Tracker
//
//  Created by Ivan Dramaliev on 10/18/05.
//  Copyright 2005 Ivan Dramaliev, 2008 Aaron VonderHaar. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/NSPredicate.h>
#import "TWorkPeriod.h"

@class TProject;

@interface TTask : NSObject <NSCoding> {

	// Attributes
	NSString *name;
	
	// Relationships
	NSMutableSet *workPeriods;
	TProject *parentProject;
}

// Mutable Attributes

- (NSString *) name;
- (void) setName: (NSString *) name;

// Immutable Attributes

- (int) totalTime;

// To-one Relationships

- (TProject*) parentProject;
- (void) setParentProject: (TProject*) project;

// To-many Relationships

- (NSSet *)workPeriods;
- (void)setWorkPeriods:(NSSet *)newWorkPeriods;
- (void)addWorkPeriodsObject:(TWorkPeriod *)aWorkPeriod;
- (void)addWorkPeriods:(NSSet *)workPeriodsToAdd;
- (void)removeWorkPeriodsObject:(TWorkPeriod *)aWorkPeriod;
- (void)removeWorkPeriods:(NSSet *)workPeriodsToRemove;
- (void)intersectWorkPeriods:(NSSet *)workPeriodsToIntersect;

// Other functions

- (int) filteredTime:(NSPredicate*) filter;
- (NSString*) serializeData:(NSString*) prefix;
- (NSMutableArray *) matchingWorkPeriods:(NSPredicate*) filter;

@end
