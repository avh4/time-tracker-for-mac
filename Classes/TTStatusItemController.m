//
//  TTStatusItemController.m
//
//  Created by Aaron VonderHaar on 2009-08-02.
//  Copyright (c) 2009 Aaron VonderHaar. All rights reserved.
//

#import "TTStatusItemController.h"
#import "AVImage.h"

@implementation TTStatusItemController

- (id)init
{
  self = [super init];
  statusItem = [[NSStatusItem alloc] init];
  //statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength] retain];
  
  playItemImage = [[AVImage imageNamed:@"playitem.png"] retain];
  playItemHighlightImage = [[AVImage imageNamed:@"playitem_hl.png"] retain];
  stopItemImage = [[AVImage imageNamed:@"stopitem.png"] retain];
  stopItemHighlightImage = [[AVImage imageNamed:@"stopitem_hl.png"] retain];
  
  //[statusItem setTarget: self];
  //[statusItem setMenu:statusItemMenu];
  //[statusItem setAction: @selector (clickedStartStopTimer:)];
  
  //[statusItem setMenu:m]; // retains m
  //[statusItem setToolTip:[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleNameKey]];
  //[statusItem setHighlightMode:NO];
  
  return self;
}

- (void)dealloc
{
  [playItemImage release];
  [playItemHighlightImage release];
  [stopItemImage release];
  [stopItemHighlightImage release];
  [statusItem release];
  [appState release];
  [super dealloc];
}

- (void)update
{
  assert(appState != nil);
  if (![appState isTimerRunning])
  {
    [statusItem setImage:playItemImage];
    image = playItemImage;
    [statusItem setAlternateImage:playItemHighlightImage];
  }
  else
  {
    [statusItem setImage:stopItemImage];
    image = stopItemImage;
    [statusItem setAlternateImage:stopItemHighlightImage];
  }
}

- (NSImage *)image
{
  return image;
}

- (NSStatusItem *)statusItem
{
  return statusItem;
}

- (void)setApplicationState:(TTApplicationState *)anAppState
{
  if (appState != anAppState)
  {
    [appState release];
    appState = [anAppState retain];
  }
}

@end
