//
//  AVImage.m
//
//  Created by __MyName__ on 2009-08-02.
//  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
//

#import "AVImage.h"

@implementation AVImage

- (id)init
{
  self = [super init];
  return self;
}

- (void)dealloc
{
  [super dealloc];
}

+ (NSImage *)imageNamed:(NSString *)name
{
  NSString *filename = [NSString stringWithFormat:@"Graphics/%@", name];
  return [[[NSImage alloc] initByReferencingFile:filename] autorelease];
  //return [NSImage imageNamed:name];
}

@end
