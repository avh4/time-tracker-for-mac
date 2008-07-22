//
//  TTDataSource.h
//  Time Tracker
//
//  Created by Aaron VonderHaar on 7/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TTDocument.h"


@interface TTDataSource : NSObject {
	
	NSArray *workPeriods;
	TTDocument *document;

}

@end
