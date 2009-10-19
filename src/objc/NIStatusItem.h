//
//  NIStatusItem.h
//  Time Tracker
//
//  Created by Aaron VonderHaar on 10/18/09.
//  Copyright 2009 Aaron VonderHaar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIImage.h"

@protocol NIStatusItem
- (id<NIStatusItem>)retain;
- (void)release;
- (void)setImage:(id<NIImage>)image;

@end
