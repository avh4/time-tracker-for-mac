//
//  TTask.h
//  Time Tracker
//
//  Created by Ivan Dramaliev on 10/18/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TWorkPeriod.h"

@interface TTask : NSObject <NSCoding> {
	NSString *_name;
	NSMutableArray *_workPeriods;
}

- (id)init;
- (id)initWithName:(NSString *)name;

- (NSString *) name;
- (void) setName: (NSString *) name;

- (void) addWorkPeriod: (TWorkPeriod *) workPeriod;
- (NSMutableArray *) workPeriods;

- (NSTimeInterval)totalTime;
- (NSTimeInterval)totalTimeInRangeFrom:(NSDate *)from to:(NSDate *)to;
- (NSArray *)workPeriodsInRangeFrom:(NSDate *)from to:(NSDate *)to;


@end
