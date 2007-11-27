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
	defaults = [NSUserDefaults standardUserDefaults];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
	return NSTerminateNow;
	
	NSArray *windows = [app windows];
    unsigned count = [windows count];
	
    // Close all open windows
    while (count--) {
        NSWindow *window = [windows objectAtIndex:count];
		[window performClose:self];
    }
    return NSTerminateNow;

}

@end
