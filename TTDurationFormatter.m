//
//  TTDurationFormatter.m
//  Time Tracker
//
//  Created by Aaron VonderHaar on 4/2/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TTDurationFormatter.h"


@implementation TTDurationFormatter

- (NSString *)stringForObjectValue:(id)anObject
{
	if ([anObject isKindOfClass:[NSNumber class]]) {
		NSNumber *aNumber = anObject;
		int seconds = [aNumber intValue];
	
		int hours = seconds / 3600;
		int minutes = (seconds % 3600) / 60;
		int secs = seconds % 60;
		return [NSString stringWithFormat: @"%@%d:%@%d:%@%d",
			(hours < 10 ? @"0" : @""), hours,
			(minutes < 10 ? @"0" : @""), minutes,
			(secs < 10 ? @"0" : @""), secs];
			
	} else {
		return [anObject description];
	}
}

@end
