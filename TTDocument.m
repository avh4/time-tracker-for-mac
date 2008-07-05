//
//  TTDocument.m
//  Time Tracker
//
//  Created by Aaron VonderHaar on 7/5/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TTDocument.h"


@implementation TTDocument

- (id) init
{
	_projects = [[NSMutableArray alloc] init];
	return self;
}

- (NSArray *) projects
{
	return _projects;
}

- (void) setProjects:(NSArray *)projs
{
	_projects = [[NSMutableArray alloc] initWithArray:projs];
}

- (void) addProject:(TProject *)proj
{
	[_projects addObject:proj];
}

- (void) removeProject:(TProject *)proj
{
	[_projects removeObject:proj];
}

@end

// This initialization function gets called when we import the Ruby module.
// It doesn't need to do anything because the RubyCocoa bridge will do
// all the initialization work.
// The rbiphonetest test framework automatically generates bundles for 
// each objective-c class containing the following line. These
// can be used by your tests.
void Init_TTDocument() { }
