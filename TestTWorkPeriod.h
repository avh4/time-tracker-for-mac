//
//  TestTWorkPeriod.h
//  Time Tracker
//
//  Created by Aaron VonderHaar on 2007-11-29.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>


@interface TestTWorkPeriod : SenTestCase {

	NSDate *t0;  // A reference time
	NSDate *t5s; // A time 5 seconds after t0
	NSDate *t1m; // A time 1 minute after t0
	NSDate *t1h1m1s; // A time 1:01:01 after t0
	NSDate *t5m2hs; // A time 5 minutes and 2.5 seconds after t0

}

@end
