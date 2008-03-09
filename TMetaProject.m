//
//  TMetaProject.m
//  Time Tracker
//
//  Created by Rainer Burgstaller on 25.11.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "TMetaProject.h"
#import "TProject.h"

@implementation TMetaProject

- (NSString*) name
{
	return @"All Projects";
}

- (void)setName:(NSString *)aName
{
	return;
}

- (int) totalTime
{
	int result = 0;
	NSEnumerator *enumProjects = [projects objectEnumerator];
	TProject *project = nil;
	while ((project = [enumProjects nextObject]) != nil) {
		result += [project totalTime];
	}
	return result;

}

- (NSSet *)tasks
{
	NSMutableSet *result = [[NSMutableSet set] autorelease];
	NSEnumerator *enumProjects = [projects objectEnumerator];
	TProject *project = nil;
	while ((project = [enumProjects nextObject]) != nil) {
		[result unionSet:[project tasks]];
	}
	return result;
}

- (void)setTasks:(NSSet *)newTasks
{
	return;
}

- (void)addTasksObject:(TTask *)aTask
{
	return;
}

- (void)addTasks:(NSSet *)tasksToAdd
{
	return;
}

- (void)removeTasksObject:(TTask *)aTask
{
	NSEnumerator *e = [projects objectEnumerator];
	TProject *project;
	while ((project = [e nextObject])) {
		[project removeTasksObject:aTask];
	}
	return;
}

- (void)removeTasks:(NSSet *)tasksToRemove
{
	NSEnumerator *e = [projects objectEnumerator];
	TProject *project;
	while ((project = [e nextObject])) {
		[project removeTasks:tasksToRemove];
	}
	return;
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

- (int) filteredTime:(NSPredicate*) filter
{
	if (filter == nil) {
		return [self totalTime];
	}
	int result = 0;
	NSEnumerator *enumProjects = [projects objectEnumerator];
	id project;
	while ((project = [enumProjects nextObject]) != nil) {
		result += [project filteredTime:filter];
	}
	return result;
}


- (NSSet *) matchingTasks:(NSPredicate*) filter //  : (bool) includeEmptyTasks
{
	if (filter == nil) {
		return [self tasks];
	}
	NSEnumerator *enumProjects = [projects objectEnumerator];
	NSMutableSet *result = [[[NSMutableArray alloc] init] autorelease];

	id project;
	while ((project = [enumProjects nextObject]) != nil) {
		[result addObjectsFromArray: [project matchingTasks:filter]];
	}
	return result;
}


@end
