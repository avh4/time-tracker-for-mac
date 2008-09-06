//
//  TTTimeProvider.h
//  Time Tracker
//
//  Created by Aaron VonderHaar on 9/5/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TTTimeProvider : NSObject {

}

- (NSDate *)todayStartTime;
- (NSDate *)todayEndTime;

- (NSDate *)yesterdayStartTime;
- (NSDate *)yesterdayEndTime;

@end
