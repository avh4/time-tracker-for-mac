//
//  TTTimeProvider.h
//  Time Tracker
//
//  Created by Aaron VonderHaar on 9/5/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TTTimeProvider : NSObject {
  
  NSDate *masterNow;

}

/* setNow can be used in testing to set a pre-determined now value.  setNow:nil to clear it. */
- (void)setNow:(NSDate *)aNow;
/* now will return the current time, or the last value passed to setNow if setNow has been called. */
- (NSDate *)now;

- (NSDate *)todayStartTime;
- (NSDate *)todayEndTime;

- (NSDate *)yesterdayStartTime;
- (NSDate *)yesterdayEndTime;

- (NSDate *)thisWeekStartTime;
- (NSDate *)thisWeekEndTime;

- (NSDate *)lastWeekStartTime;
- (NSDate *)lastWeekEndTime;

- (NSDate *)weekBeforeLastStartTime;
- (NSDate *)weekBeforeLastEndTime;

- (NSDate *)thisMonthStartTime;
- (NSDate *)thisMonthEndTime;

- (NSDate *)lastMonthStartTime;
- (NSDate *)lastMonthEndTime;

@end
