/* MainController */

#import <Cocoa/Cocoa.h>
#import "TProject.h"
#import "TTask.h"
#import "TWorkPeriod.h"

@interface MainController : NSObject
{
	NSUserDefaults *defaults;
	IBOutlet NSApplication *app;	
}

@end
