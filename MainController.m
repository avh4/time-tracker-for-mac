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
	NSDocumentController *dc = [NSDocumentController sharedDocumentController];

	if ( [[dc documents] count] > 0) {
		// if the window is still open, give it focus
		NSDocument *doc = [[dc documents] objectAtIndex:0];
		NSWindowController *wc = [[doc windowControllers] objectAtIndex:0];
		[[wc window] makeKeyAndOrderFront:self];
	} else {
		// if there are no windows open, create a new one
		[dc newDocument:self];
	}
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    return NSTerminateNow;	
}

@end
