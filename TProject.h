//
//  TProject.h
//  Time Tracker
//
//  Created by Ivan Dramaliev on 10/18/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TTask.h"
#import "IProject.h"

@interface TProject : NSObject <NSCoding, IProject> {
	NSString *_name;
	NSMutableArray *_tasks;
	int _totalTime;
}

// Mutable Attributes

- (NSString *) name;
- (void) setName: (NSString *) name;

// Immutable Attributes

- (int) totalTime;

// To-many Relationships

- (NSMutableArray *) tasks;
- (void) addTask: (TTask *) task;
- (id<IProject>) removeTask:(TTask*)task;

- (NSMutableArray *) matchingTasks:(NSPredicate*) filter;
- (int) filteredTime:(NSPredicate*) filter;

// Other functions

- (void) updateTotalTime;
- (NSString*) serializeData;
@end
