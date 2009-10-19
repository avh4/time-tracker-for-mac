//
//  InspectorController.h
//  Time Tracker
//
//  Created by Aaron VonderHaar on 10/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TWorkPeriod.h"


@interface InspectorController : NSObject {
	
	IBOutlet NSDatePicker *dpStartTime;
	IBOutlet NSDatePicker *dpEndTime;
	
	TWorkPeriod *workPeriod;

}

#pragma mark controller methods

- (void)setWorkPeriod:(TWorkPeriod *)wp;

#pragma mark view methods

- (void)workPeriodChanged:(id)sender;

#pragma mark protected methods

- (void)setDpStartTime:(NSDatePicker *)dp;
- (void)setDpEndTime:(NSDatePicker *)dp;
- (void)_setWorkPeriod:(TWorkPeriod *)wp;

@end
