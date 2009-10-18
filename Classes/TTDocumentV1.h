//
//  TTDocumentV1.h
//  Time Tracker
//
//  Created by Aaron VonderHaar on 7/5/08.
//  Copyright 2008 Aaron VonderHaar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TProject.h"

@interface TTDocumentV1 : NSObject {
	NSMutableArray *_projects;
}

- (id)init;

- (NSArray *)projects;
- (void)setProjects:(NSArray *)projs;
- (void)addProject:(TProject *)proj;
- (void)createProject:(NSString *)name;
- (void)removeProject:(TProject *)proj;
- (id)objectInProjectsAtIndex:(int)index;
- (void)moveProject:(TProject *)proj toIndex:(int)index;

- (NSData *)dataOfType:(NSString *)aType error:(NSError **)outError;

@end
