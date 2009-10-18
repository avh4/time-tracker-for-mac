//
//  TTStatusItemController.h
//
//  Created by __MyName__ on 2009-08-02.
//  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TTApplicationState.h"

@interface TTStatusItemController : NSObject
{
  IBOutlet TTApplicationState* appState;
  
  NSStatusItem *statusItem;
  NSImage *image;
  
  NSImage *playItemImage;
  NSImage *playItemHighlightImage;
  NSImage *stopItemImage;
  NSImage *stopItemHighlightImage;
}

- (void)update;

- (NSStatusItem *)statusItem;
- (NSImage *)image;

- (void)setApplicationState:(TTApplicationState *)anAppState;

@end
