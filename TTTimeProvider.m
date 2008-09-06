//
//  TTTimeProvider.m
//  Time Tracker
//
//  Created by Aaron VonderHaar on 9/5/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TTTimeProvider.h"


@implementation TTTimeProvider

- (NSDate *)todayStartTime
{
	NSDate *now = [NSDate date];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *todayStartComps = [gregorian 
		components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
		fromDate:now];
	NSDate *todayStart = [gregorian dateFromComponents:todayStartComps];
	return todayStart;
}

- (NSDate *)todayEndTime
{
	NSDate *now = [NSDate date];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *todayEndComps = [gregorian 
		components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
		fromDate:now];
	NSDate *todayEnd = [gregorian dateFromComponents:todayEndComps];
	todayEnd = [todayEnd addTimeInterval:60*60*24];
	NSLog(@"%@", todayEnd);
	return todayEnd;
}

@end
