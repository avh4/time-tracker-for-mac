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

- (void)showMainWindow:(id)sender
{
	[[NSDocumentController sharedDocumentController] newDocument:self];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    return NSTerminateNow;	
}

@end
