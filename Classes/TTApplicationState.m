//
//  TTApplicationState.m
//
//  Created by Aaron VonderHaar on 2009-08-02.
//  Copyright (c) 2009 Aaron VonderHaar. All rights reserved.
//

#import "TTApplicationState.h"

@implementation TTApplicationState

- (id)init
{
  self = [super init];
  return self;
}

- (void)dealloc
{
  [super dealloc];
}

- (BOOL)isTimerRunning
{
  return false;
}

@end
