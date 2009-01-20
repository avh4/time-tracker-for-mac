//
//  TTTimeProvider.m
//  Time Tracker
//
//  Created by Aaron VonderHaar on 9/5/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TTTimeProvider.h"


@implementation TTTimeProvider

- (void)setNow:(NSDate *)aNow
{
  [masterNow release];
  masterNow = [aNow retain];
}

- (NSDate *)now
{
  if (masterNow != nil)
  {
    return masterNow;
  }
  else
  {
    return [NSDate date];
  }
}

- (void)deallc
{
  [masterNow release];
  [super dealloc];
}

- (NSDate *)todayStartTime
{
  NSDate *now = [self now];
	NSCalendar *gregorian = [NSCalendar currentCalendar];
	NSDateComponents *todayStartComps = [gregorian 
		components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
		fromDate:now];
	NSDate *todayStart = [gregorian dateFromComponents:todayStartComps];
	return todayStart;
}

- (NSDate *)todayEndTime
{
  NSDate *now = [self now];
	NSCalendar *gregorian = [NSCalendar currentCalendar];
	NSDateComponents *todayEndComps = [gregorian 
		components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
		fromDate:now];
	NSDate *todayEnd = [gregorian dateFromComponents:todayEndComps];
	todayEnd = [todayEnd addTimeInterval:60*60*24];
	return todayEnd;
}

- (NSDate *)yesterdayStartTime
{
  NSDate *now = [self now];
	NSCalendar *gregorian = [NSCalendar currentCalendar];
	NSDateComponents *rangeStartComps = [gregorian 
		components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
		fromDate:now];
	NSDate *rangeStart = [gregorian dateFromComponents:rangeStartComps];
	rangeStart = [rangeStart addTimeInterval:-60*60*24];
	return rangeStart;
}

- (NSDate *)yesterdayEndTime
{
  NSDate *now = [self now];
	NSCalendar *gregorian = [NSCalendar currentCalendar];
	NSDateComponents *rangeEndComps = [gregorian 
		components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
		fromDate:now];
	NSDate *rangeEnd = [gregorian dateFromComponents:rangeEndComps];
	return rangeEnd;
}

- (NSDate *)thisWeekStartTime
{
  NSDate *now = [self now];
	NSCalendar *gregorian = [NSCalendar currentCalendar];
	NSDateComponents *rangeStartComps = [gregorian 
		components:NSYearCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit
		fromDate:now];
	[rangeStartComps setWeekday:[gregorian firstWeekday]];
	NSDate *rangeStart = [gregorian dateFromComponents:rangeStartComps];
	return rangeStart;
}

- (NSDate *)thisWeekEndTime
{
  NSDate *now = [self now];
	NSCalendar *gregorian = [NSCalendar currentCalendar];
	NSDateComponents *rangeEndComps = [gregorian 
		components:NSYearCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit
		fromDate:now];
	[rangeEndComps setWeekday:[gregorian firstWeekday]];
	NSDate *rangeEnd = [gregorian dateFromComponents:rangeEndComps];
	rangeEnd = [rangeEnd addTimeInterval:60*60*24*7];
	return rangeEnd;
}

- (NSDate *)lastWeekStartTime
{
  NSDate *now = [self now];
	NSCalendar *gregorian = [NSCalendar currentCalendar];
	NSDateComponents *rangeStartComps = [gregorian 
		components:NSYearCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit
		fromDate:now];
	[rangeStartComps setWeekday:[gregorian firstWeekday]];
	NSDate *rangeStart = [gregorian dateFromComponents:rangeStartComps];
	rangeStart = [rangeStart addTimeInterval:-60*60*24*7];
	return rangeStart;
}

- (NSDate *)lastWeekEndTime
{
  NSDate *now = [self now];
	NSCalendar *gregorian = [NSCalendar currentCalendar];
	NSDateComponents *rangeEndComps = [gregorian 
		components:NSYearCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit
		fromDate:now];
	[rangeEndComps setWeekday:[gregorian firstWeekday]];
	NSDate *rangeEnd = [gregorian dateFromComponents:rangeEndComps];
	return rangeEnd;
}

- (NSDate *)weekBeforeLastStartTime
{
  NSDate *now = [self now];
	NSCalendar *gregorian = [NSCalendar currentCalendar];
	NSDateComponents *rangeStartComps = [gregorian
		components:NSYearCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit
		fromDate:now];
	[rangeStartComps setWeekday:[gregorian firstWeekday]];
	NSDate *rangeStart = [gregorian dateFromComponents:rangeStartComps];
	rangeStart = [rangeStart addTimeInterval:-2*60*60*24*7];
	return rangeStart;
}

- (NSDate *)weekBeforeLastEndTime
{
  NSDate *now = [self now];
	NSCalendar *gregorian = [NSCalendar currentCalendar];
	NSDateComponents *rangeEndComps = [gregorian
		components:NSYearCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit
		fromDate:now];
	[rangeEndComps setWeekday:[gregorian firstWeekday]];
	NSDate *rangeEnd = [gregorian dateFromComponents:rangeEndComps];
	rangeEnd = [rangeEnd addTimeInterval:-60*60*24*7];
	return rangeEnd;
}

- (NSDate *)thisMonthStartTime
{
  NSDate *now = [self now];
	NSCalendar *gregorian = [NSCalendar currentCalendar];
	NSDateComponents *rangeStartComps = [gregorian 
		components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
		fromDate:now];
	[rangeStartComps setDay:1];
	NSDate *rangeStart = [gregorian dateFromComponents:rangeStartComps];
	return rangeStart;
}

- (NSDate *)thisMonthEndTime
{
  NSDate *now = [self now];
	NSCalendar *gregorian = [NSCalendar currentCalendar];
	NSDateComponents *rangeEndComps = [gregorian 
		components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
		fromDate:now];
	[rangeEndComps setDay:1];
	[rangeEndComps setMonth:[rangeEndComps month]+1];
	NSDate *rangeEnd = [gregorian dateFromComponents:rangeEndComps];
	return rangeEnd;
}

- (NSDate *)lastMonthStartTime
{
  NSDate *now = [self now];
	NSCalendar *gregorian = [NSCalendar currentCalendar];
	NSDateComponents *rangeStartComps = [gregorian 
		components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
		fromDate:now];
	[rangeStartComps setDay:1];
	[rangeStartComps setMonth:[rangeStartComps month]-1];
	NSDate *rangeStart = [gregorian dateFromComponents:rangeStartComps];
	return rangeStart;
}

- (NSDate *)lastMonthEndTime
{
  NSDate *now = [self now];
	NSCalendar *gregorian = [NSCalendar currentCalendar];
	NSDateComponents *rangeEndComps = [gregorian 
		components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
		fromDate:now];
	[rangeEndComps setDay:1];
	NSDate *rangeEnd = [gregorian dateFromComponents:rangeEndComps];
	return rangeEnd;
}



@end
