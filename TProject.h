//
//  TProject.h
//  Time Tracker
//
//  Created by Ivan Dramaliev on 10/18/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TTask.h"

@interface TProject : NSObject <NSCoding> {

	//Attributes
	NSString *name;
	
	// Relationships
	NSMutableSet *tasks;
}

// Mutable Attributes

- (NSString *) name;
- (void) setName: (NSString *) name;

// Immutable Attributes

- (int) totalTime;

// To-many Relationships

- (NSSet *)tasks;
- (void)setTasks:(NSSet *)newTasks;
- (void)addTasksObject:(TTask *)aTask;
- (void)addTasks:(NSSet *)tasksToAdd;
- (void)removeTasksObject:(TTask *)aTask;
- (void)removeTasks:(NSSet *)tasksToRemove;
- (void)intersectTasks:(NSSet *)tasksToIntersect;

// Other functions

- (NSMutableArray *) matchingTasks:(NSPredicate*) filter;
- (int) filteredTime:(NSPredicate*) filter;
- (NSString*) serializeData;

@end
