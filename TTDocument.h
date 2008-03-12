//
//  TTDocument.h
//  Time Tracker
//
//  Created by Aaron VonderHaar on 3/11/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TProject.h"

#define CSV_TYPE @"CSV"
#define TT_V1_TYPE @"Time Tracker Version 1 Data File"
#define TT_V2_TYPE @"Time Tracker Version 2 Data File"


@interface TTDocument : NSDocument {
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

@end
