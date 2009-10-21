//
//  TTStatusItemController.m
//
//  Created by Aaron VonderHaar on 2009-08-02.
//  Copyright (c) 2009 Aaron VonderHaar. All rights reserved.
//

#import "TTStatusItemController.h"

@implementation TTStatusItemController

- (id)initWithStatusItem:(id<NIStatusItem>)aStatusItem 
               resources:(id<TTResources>)aResources
        applicationState:(TTApplicationState*)anAppState
{
  self = [super init];
  statusItem = [aStatusItem retain];
  appState = [anAppState retain];
  
  playItemImage = [[aResources playItemImage] retain];//[[NSImage imageNamed:@"playitem.png"] retain];
  //playItemHighlightImage = [[NSImage imageNamed:@"playitem_hl.png"] retain];
  stopItemImage = [[aResources stopItemImage] retain];//[[NSImage imageNamed:@"stopitem.png"] retain];
  //stopItemHighlightImage = [[NSImage imageNamed:@"stopitem_hl.png"] retain];
  
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
  assert(playItemImage != nil);
  assert(stopItemImage != nil);
  if (![appState isTimerRunning])
  {
    [statusItem setImage:playItemImage];
    [statusItem setTitle:@"Start"];
    image = playItemImage;
    //[statusItem setAlternateImage:playItemHighlightImage];
  }
  else
  {
    [statusItem setImage:stopItemImage];
    [statusItem setTitle:@"Stop"];
    image = stopItemImage;
    //[statusItem setAlternateImage:stopItemHighlightImage];
  }
}

@end
