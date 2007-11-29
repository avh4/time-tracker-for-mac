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
	
	NSArray *windows = [sender windows];
    unsigned count = [windows count];
	
    // Close all open windows
    while (count--) {
        NSWindow *window = [windows objectAtIndex:count];
		[window performClose:self];
    }
	NSLog(@"Terminating");
    return NSTerminateNow;

}

@end
