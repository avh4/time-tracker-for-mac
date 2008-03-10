//
//  TimeTrackerDocument.h
//  Time Tracker
//
//  Created by Aaron VonderHaar on 3/8/2008.
//  Copyright 2008 Aaron VonderHaar. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TProject.h"


@interface TimeTrackerDocument : NSObject {
	// Relationships
	NSMutableSet *projects;
}

// To-many Relationships

- (NSSet *)projects;
- (void)setProjects:(NSSet *)newProjects;
- (void)addProjectsObject:(TProject *)aTask;
- (void)addProjects:(NSSet *)projectsToAdd;
- (void)removeProjectsObject:(TProject *)aTask;
- (void)removeProjects:(NSSet *)projectsToRemove;
- (void)intersectProjects:(NSSet *)projectsToIntersect;

// Other functions

- (id)init;
- (id)initFromStorage;
- (void)saveData:(NSString *)path;
- (NSString *)serializeData;


@end
