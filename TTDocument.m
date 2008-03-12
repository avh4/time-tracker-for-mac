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

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
	if ([typeName isEqualToString:CSV_TYPE]) {
	
		NSMutableString *result = [NSMutableString stringWithString:@"\"Project\";\"Task\";\"Date\";\"Start\";\"End\";\"Duration\";\"Comment\"\n"];
		NSEnumerator *enumerator = [projects objectEnumerator];
		id anObject;
		
		while (anObject = [enumerator nextObject])
		{
			[result appendString:[anObject serializeData]];
		}
		return [result dataUsingEncoding:NSUnicodeStringEncoding];
		
	} else if ([typeName isEqualToString:TT_V2_TYPE]) {
	
		NSData *documentData = nil;
		NSData *projectData=[NSKeyedArchiver archivedDataWithRootObject:projects];
	
		NSMutableDictionary *rootObject = [NSMutableDictionary dictionary]; 
		[rootObject setObject:projectData forKey:@"ProjectTimes"];

		documentData = [NSKeyedArchiver archivedDataWithRootObject:rootObject];
		return documentData;

	} else if ([typeName isEqualToString:TT_V1_TYPE]) {
		// not necessary to store in the old format
		/*[[NSUserDefaults standardUserDefaults] setObject:theData forKey:@"ProjectTimes"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		*/
		return nil;
		
	} else {
	
		return nil;
		
	}
	
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
	if ([typeName isEqualToString:CSV_TYPE]) {
	
		// Cannot read CSV files (can only export them)
		if (outError) {
			// XXX Need to figure out the correct way to fill in these arguments:
			*outError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteUnsupportedSchemeError userInfo:nil];
		}
		return FALSE;
		
	} else if ([typeName isEqualToString:TT_V2_TYPE]) {

		NSDictionary *rootObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
		NSData *projectData = [rootObject  valueForKey:@"ProjectTimes"];
		if (projectData != nil) {
			NSArray *projectArray = [NSKeyedUnarchiver unarchiveObjectWithData:projectData];
			[projects release];
			projects = [[NSMutableSet alloc] initWithArray:projectArray];
		}
		return TRUE;
		
	} else if ([typeName isEqualToString:TT_V1_TYPE]) {
	
		NSArray *projectArray = [NSUnarchiver unarchiveObjectWithData:data];
		[projects release];
		projects = [[NSMutableSet alloc] initWithArray:projectArray];
		return TRUE;
		
	}

	// XXX should indicate that the requested type is not supported
	return FALSE;
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
	assert(newProjects != nil);
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
