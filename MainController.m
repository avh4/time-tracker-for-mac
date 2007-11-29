#include <IOKit/IOKitLib.h>

#import "MainController.h"
#import "TTask.h"
#import "TProject.h"
#import "TWorkPeriod.h"

@implementation MainController

- (id) init
{
	return self;
}

- (void)awakeFromNib
{
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    return NSTerminateNow;	
}

@end
