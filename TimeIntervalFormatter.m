//
//  TimeIntervalFormatter.m
//  Time Tracker
//
//  Created by Ivan Dramaliev on 10/18/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "TimeIntervalFormatter.h"


@implementation TimeIntervalFormatter

+ (NSString *) secondsToString: (int) seconds
{
	int hours = seconds / 3600;
	int minutes = (seconds % 3600) / 60;
	int secs = seconds % 60;
	return [NSString stringWithFormat: @"%@%d:%@%d:%@%d",
		(hours < 10 ? @"0" : @""), hours,
		(minutes < 10 ? @"0" : @""), minutes,
		(secs < 10 ? @"0" : @""), secs];
}

@end

// This initialization function gets called when we import the Ruby module.
// It doesn't need to do anything because the RubyCocoa bridge will do
// all the initialization work.
// The rbiphonetest test framework automatically generates bundles for 
// each objective-c class containing the following line. These
// can be used by your tests.
void Init_TimeIntervalFormatter() { }