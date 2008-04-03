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
		return [NSString stringWithFormat: @"%02d:%02d:%02d",
			hours, minutes, secs];
			
	} else {
		return [anObject description];
	}
}

- (BOOL)getObjectValue:(id *)anObject forString:(NSString *)string errorDescription:(NSString **)error
{
	anObject = nil;
	if (error != nil) (*error) = @"Reverse conversion is not supported.";
	return NO;
}

@end
