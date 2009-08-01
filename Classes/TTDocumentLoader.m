//
//  TTDocumentLoader.m
//  Time Tracker
//
//  Created by Aaron VonderHaar on 2/16/09.
//  Copyright 2009 Aaron VonderHaar. All rights reserved.
//

#import "TTDocumentLoader.h"

#define DEFAULTS_KEY_PROJECT_DATA @"ProjectTimes"

@implementation TTDocumentLoader

#pragma mark Load TTDocumentV1

- (TTDocumentV1 *)loadDocument
{
	NSData *theData=[[NSUserDefaults standardUserDefaults] dataForKey:DEFAULTS_KEY_PROJECT_DATA];
  
  return [self loadDocumentFromData:theData];
}

- (TTDocumentV1 *)loadDocumentFromFile:(NSString *)filename
{
  TTDocumentV1 *document = [[TTDocumentV1 alloc] init];
	
  NSMutableArray *projects = (NSMutableArray *)[NSMutableArray arrayWithArray: [NSUnarchiver unarchiveObjectWithFile:filename]];
  [document setProjects:projects];
  
  return document;
}

- (TTDocumentV1 *)loadDocumentFromData:(NSData *)theData
{
  TTDocumentV1 *document = [[TTDocumentV1 alloc] init];
	
	if (theData != nil)
	{
		NSMutableArray *projects = (NSMutableArray *)[NSMutableArray arrayWithArray: [NSUnarchiver unarchiveObjectWithData:theData]];
		[document setProjects:projects];
	}
  
  return document;
}

#pragma mark Save TTDocumentV1

- (void)saveDocument:(TTDocumentV1 *)document
{
  NSData *theData=[NSArchiver archivedDataWithRootObject:[document projects]];
	[[NSUserDefaults standardUserDefaults] setObject:theData forKey:DEFAULTS_KEY_PROJECT_DATA];
	[[NSUserDefaults standardUserDefaults] synchronize];  
}

- (void)saveDocument:(TTDocumentV1 *)document toFile:(NSString *)filename
{
  [NSArchiver archiveRootObject:[document projects] toFile:filename];
}


@end
