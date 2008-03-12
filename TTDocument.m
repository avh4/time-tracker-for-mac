//
//  TTDocument.m
//  Time Tracker
//
//  Created by Aaron VonderHaar on 3/11/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TTDocument.h"
#import "TProject.h"


@implementation TTDocument

- (NSString *)windowNibName {
    // Implement this to return a nib to load OR implement -makeWindowControllers to manually create your controllers.
    return @"TimeTrackerMainWindow";
}

- (NSData *)dataRepresentationOfType:(NSString *)type {
    // Implement to provide a persistent data representation of your document OR remove this and implement the file-wrapper or file path based save methods.
    return nil;
}

- (BOOL)loadDataRepresentation:(NSData *)data ofType:(NSString *)type {
    // Implement to load a persistent data representation of your document OR remove this and implement the file-wrapper or file path based load methods.
    return YES;
}

- (id)init
{
	[super init];
	projects = [[NSMutableSet alloc] init];
	TProject *proj = [[[TProject alloc] init] autorelease];
	[projects addObject:proj];
	return self;
}

- (void)dealloc
{
	[projects release];
	[super dealloc];
}

- (NSSet *)projects
{
	return projects;
}

- (void)setProjects:(NSSet*)newProjects
{
	if (projects != newProjects) {
		[projects release];
		projects = [newProjects mutableCopy];
	}
}

- (void)addProjectsObject:(TProject *)aTask
{
	[projects addObject:aTask];
}

- (void)addProjects:(NSSet *)projectsToAdd
{
	[projects unionSet:projectsToAdd];
}

- (void)removeProjectsObject:(TProject *)aTask
{
	[projects removeObject:aTask];
}

- (void)removeProjects:(NSSet *)projectsToRemove
{
	[projects minusSet:projectsToRemove];
}

- (void)intersectProjects:(NSSet *)projectsToIntersect
{
	[projects intersectSet:projectsToIntersect];
}

@end
