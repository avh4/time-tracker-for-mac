//
//  TTStatusItemController.h
//
//  Created by Aaron VonderHaar on 2009-08-02.
//  Copyright (c) 2009 Aaron VonderHaar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTApplicationState.h"
#import "TTResources.h"
#import "NIStatusItem.h"
#import "NIImage.h"

@interface TTStatusItemController : NSObject
{
  TTApplicationState* appState;
  
  id<NIStatusItem> statusItem;
  id<NIImage> image;
  
  id<NIImage> playItemImage;
  id<NIImage> playItemHighlightImage;
  id<NIImage> stopItemImage;
  id<NIImage> stopItemHighlightImage;
}

- (id)initWithStatusItem:(id<NIStatusItem>)aStatusItem 
               resources:(id<TTResources>)aResources
        applicationState:(TTApplicationState*)anAppState;

- (void)update;

@end
