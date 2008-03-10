//
//  TimeTrackerDocument.m
//  Time Tracker
//
//  Created by Aaron VonderHaar on 3/8/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TimeTrackerDocument.h"


@implementation TimeTrackerDocument

- (id)init
{
	projects = [NSMutableSet set];
	return self;
}

- (id)initFromStorage
{
	if ([self dataFileExists]) {
		NSString * path = [self pathForDataFile]; 
		NSDictionary * rootObject; 
		rootObject = [NSKeyedUnarchiver unarchiveObjectWithFile:path]; 
		NSData *theData = nil;
		theData = [rootObject  valueForKey:@"ProjectTimes"];
		if (theData != nil) {
			projects = (NSMutableArray *)[[NSMutableArray arrayWithArray: [NSKeyedUnarchiver unarchiveObjectWithData:theData]] retain];
		}
	} else {
		// use the old unarchiver
		defaults = [NSUserDefaults standardUserDefaults];
	
		NSData *theData = nil;
		theData=[[NSUserDefaults standardUserDefaults] dataForKey:@"ProjectTimes"];
		if (theData != nil) {
			projects = (NSMutableArray *)[[NSMutableArray arrayWithArray: [NSUnarchiver unarchiveObjectWithData:theData]] retain];
		}
	}
	if (_projects == nil) {
		_projects = [NSMutableArray array];
	}
	_projects_lastTask = [[NSMutableDictionary alloc] initWithCapacity:[_projects count]];
	
	return self;
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

- (void)saveData:(NSString *)path
{
	NSData *theData=[NSKeyedArchiver archivedDataWithRootObject:projects];
	NSMutableDictionary * rootObject; 
	rootObject = [NSMutableDictionary dictionary]; 
	//[rootObject setValue: [self mailboxes] forKey:@"mailboxes"]; 
	[rootObject setObject:theData forKey:@"ProjectTimes"];
	[NSKeyedArchiver archiveRootObject: rootObject toFile: path];
	
	// not necessary to store in the old format
	/*[[NSUserDefaults standardUserDefaults] setObject:theData forKey:@"ProjectTimes"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	*/	
}

- (NSString *)serializeData 
{
	NSMutableString *result = [NSMutableString stringWithString:@"\"Project\";\"Task\";\"Date\";\"Start\";\"End\";\"Duration\";\"Comment\"\n"];
	NSEnumerator *enumerator = [_projects objectEnumerator];
	id anObject;
 
	while (anObject = [enumerator nextObject])
	{
		[result appendString:[anObject serializeData]];
	}
	return result;
}

@end
