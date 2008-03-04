//
//  TTask.h
//  Time Tracker
//
//  Created by Ivan Dramaliev on 10/18/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/NSPredicate.h>
#import "TWorkPeriod.h"
#import "ITask.h"

@class TProject;

@interface TTask : NSObject <NSCoding, ITask> {
	NSString *_name;
	int _totalTime;
	NSMutableArray *_workPeriods;
	TProject* _parent;
}

// Mutable Attributes

- (NSString *) name;
- (void) setName: (NSString *) name;

// Immutable Attributes

- (int) totalTime;
- (int) filteredTime:(NSPredicate*) filter;

// To-one Relationships

- (TProject*) parentProject;
- (void) setParentProject: (TProject*) project;

// To-many Relationships

- (void) addWorkPeriod: (TWorkPeriod *) workPeriod;
- (id<ITask>) removeWorkPeriod:(TWorkPeriod*)period;
- (NSMutableArray *) workPeriods;
- (NSMutableArray *) matchingWorkPeriods:(NSPredicate*) filter;

// Other functions

- (void) updateTotalTime;
- (NSString*) serializeData:(NSString*) prefix;

@end
