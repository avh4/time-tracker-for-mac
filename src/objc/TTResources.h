//
//  TTResources.h
//  Time Tracker
//
//  Created by Aaron VonderHaar on 10/18/09.
//  Copyright 2009 Aaron VonderHaar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIImage.h"


@protocol TTResources
- (id<NIImage>)playItemImage;
- (id<NIImage>)stopItemImage;
@end
