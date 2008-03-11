//
//  TimeTrackerDocument.h
//  Time Tracker
//
//  Created by Aaron VonderHaar on 3/8/2008.
//  Copyright 2008 Aaron VonderHaar. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TProject.h"

#define CSV_TYPE @"CSV"
#define TT_V1_TYPE @"Time Tracker Version 1 Data File"
#define TT_V2_TYPE @"Time Tracker Version 2 Data File"


@interface TimeTrackerDocument : NSDocument {
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
- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError;
- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError;

@end
