//
//  TimeTrackerDocument.h
//  Time Tracker
//
//  Created by Aaron VonderHaar on 2007-11-26.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import "TProject.h"
#import "TTask.h"
#import "TWorkPeriod.h"

@interface TimeTrackerDocument : NSDocument {
	
	NSImage *playItemImage;
	NSImage *playItemHighlightImage;	
	NSImage *stopItemImage;
	NSImage *stopItemHighlightImage;
	NSImage *playToolImage;
	NSImage *stopToolImage;
	NSImage *addTaskToolImage;
	NSImage *addProjectToolImage;
		
	NSTimer *timer;
	
	NSStatusItem *statusItem;
	NSToolbarItem *startstopToolbarItem;

    IBOutlet NSWindow *mainWindow;
	IBOutlet NSMenuItem *startMenuItem;
	IBOutlet NSTextField *tfActiveProject;
	IBOutlet NSTextField *tfActiveTask;
    IBOutlet NSTableView *tvProjects;
    IBOutlet NSTableView *tvTasks;
    IBOutlet NSTableView *tvWorkPeriods;
    IBOutlet NSPanel *panelEditWorkPeriod;
    IBOutlet NSPanel *panelIdleNotification;
    
	IBOutlet NSDatePicker *dtpEditWorkPeriodStartTime;
	IBOutlet NSDatePicker *dtpEditWorkPeriodEndTime;
	
	NSMutableArray *_projects;
	NSMutableDictionary *_projects_lastTask;
	TProject *_selProject;
	TTask *_selTask;
	TWorkPeriod *_curWorkPeriod;
	TProject *_curProject;
	TTask *_curTask;
	NSDateFormatter *_dateFormatter;

	NSDate *_lastNonIdleTime;
	int timeSinceSave;
}

- (IBAction)clickedAddProject:(id)sender;
- (IBAction)clickedAddTask:(id)sender;
- (IBAction)clickedStartStopTimer:(id)sender;
- (IBAction)clickedDelete:(id)sender;
- (IBAction)clickedChangeWorkPeriod:(id)sender;
- (IBAction)clickedCountIdleTimeYes:(id)sender;
- (IBAction)clickedCountIdleTimeNo:(id)sender;
- (IBAction) actionExport:(id)sender;

- (void) timerFunc: (NSTimer *) timer;
- (void) stopTimer:(NSDate*)endTime;
- (void) stopTimer;
- (void) startTimer;
- (void) createTask;
- (void) createProject;
- (int)idleTime;
- (void) saveData;

- (void) updateStartStopState;
- (void) updateProminentDisplay;

- (NSArray *) projects;

- (BOOL) validateUserInterfaceItem:(id)anItem;

@end
