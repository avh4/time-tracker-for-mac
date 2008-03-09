//
//  TMetaProject.h
//  Time Tracker
//
//  Created by Rainer Burgstaller on 25.11.07.
//  Copyright 2007-2008 Rainer Burgstaller, 2008 Aaron VonderHaar. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TProject.h"

@interface TMetaProject : TProject {
	NSMutableSet *projects;
}

// Overrides

- (NSString *)name;
- (void)setName:(NSString *)aName;

- (int)totalTime;

- (NSSet *)tasks;
- (void)setTasks:(NSSet *)newTasks;
- (void)addTasksObject:(TTask *)aTask;
- (void)addTasks:(NSSet *)tasksToAdd;
- (void)removeTasksObject:(TTask *)aTask;
- (void)removeTasks:(NSSet *)tasksToRemove;
//- (void)intersectTasks:(NSSet *)tasksToIntersect;

// To-many Relationships

- (NSSet *)projects;
- (void)setProjects:(NSSet *)newProjects;
- (void)addProjectsObject:(TProject *)aTask;
- (void)addProjects:(NSSet *)projectsToAdd;
- (void)removeProjectsObject:(TProject *)aTask;
- (void)removeProjects:(NSSet *)projectsToRemove;
- (void)intersectProjects:(NSSet *)projectsToIntersect;

// Other functions

- (int) filteredTime:(NSPredicate*) filter;
- (NSSet *) matchingTasks:(NSPredicate*) filter;

@end
