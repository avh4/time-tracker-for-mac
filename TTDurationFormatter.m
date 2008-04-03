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
		return @"Number";
	} else {
		return [anObject description];
	}
}

@end
