#include <IOKit/IOKitLib.h>
#include <assert.h>

#import "MainController.h"
#import "TTask.h"
#import "TProject.h"
#import "TimeIntervalFormatter.h"
#import "TWorkPeriod.h"
#import "TMetaProject.h"
#import "TDateTransformer.h"

@implementation MainController

- (id) init
{
	_projects = [NSMutableArray new];
	_selProject = nil;
	_selTask = nil;
	_curTask = nil;
	_curProject = nil;
	_curWorkPeriod = nil;
	timer = nil;
	timeSinceSave = 0;
	_metaProject = [[TMetaProject alloc] init];
	_metaTask = [[TMetaTask alloc] init];
	[_metaProject setProjects: _projects];
	[_metaTask setTasks: [_metaProject tasks]];
	
	[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
	_dateFormatter = [[NSDateFormatter alloc] init];
	[_dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[_dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	_timeValueFormatter = [[TTimeTransformer alloc] init];
	_dateValueFormatter = [[TDateTransformer alloc] init];
	_intervalValueFormatter = [[TimeIntervalFormatter alloc] init];
	[NSValueTransformer setValueTransformer:_timeValueFormatter forName:@"TimeToStringFormatter"];
	[NSValueTransformer setValueTransformer:_dateValueFormatter forName:@"DateToStringFormatter"];
	[NSValueTransformer setValueTransformer:_intervalValueFormatter forName:@"TimeIntervalToStringFormatter"];
	
	return self;
}



- (int)selectedTaskRow 
{
	return [tvTasks selectedRow] - 1;
}

- (int)selectedProjectRow
{
	return [tvProjects selectedRow] - 1;
}

- (int)selectedWorkPeriodRow
{
	
	return [workPeriodController selectionIndex];
}


- (IBAction)clickedStartStopTimer:(id)sender
{
	if (timer == nil) {
		[self startTimer];
	} else {
		[self stopTimer];
	}
}


- (BOOL)validateMenuItem:(NSMenuItem *) anItem {
	return YES;
}


- (void)startTimer
{
	assert([_selTask isKindOfClass:[TTask class]]);
	// assert timer == nil
	if (timer != nil) return;
	
	// if there is no project selected, create a new one
	if (_selProject == nil)
		[self createProject];

	// if there is no task selected, create a new one
	if (_selTask == nil)
		[self createTask];
	
	timer = [NSTimer scheduledTimerWithTimeInterval: 1 target: self selector: @selector (timerFunc:)
					userInfo: nil repeats: YES];
	
	[self updateStartStopState];
	
	_curWorkPeriod = [TWorkPeriod new];
	[_curWorkPeriod setStartTime: [NSDate date]];
	[_curWorkPeriod setEndTime: [NSDate date]];
	
	[(TTask*)_selTask addWorkPeriod: _curWorkPeriod];
	[tvWorkPeriods reloadData];	
	_curProject = _selProject;
	_curTask = _selTask;
	
	[self updateProminentDisplay];
	
	// assert timer != nil
	// assert _curProject != nil
	// assert _curTask != nil
}

- (void)stopTimer
{
	[self stopTimer:[NSDate date]];
}

- (void)stopTimer:(NSDate*)endTime
{
	// assert timer != nil
	if (timer == nil) return;
	
	[timer invalidate];
	timer = nil;
	
	[_curWorkPeriod setEndTime:endTime];
	[_curTask updateTotalTime];
	[_curProject updateTotalTime];
	_curWorkPeriod = nil;
	_curProject = nil;
	_curTask = nil;
	
	[self saveData];
	
	[self updateStartStopState];
	
	[tvProjects reloadData];
	[tvTasks reloadData];
	[tvWorkPeriods reloadData];
	
	[self updateProminentDisplay];
	
	//[defaults setObject: [NSNumber numberWithInt: totalTime] forKey: @"TotalTime"];
	
	// assert timer == nil
	// assert _curProject == nil
	// assert _curTask == nil
}

- (void)toolbarWillAddItem:(NSNotification *)notification
{
}

- (void)toolbarDidRemoveItem:(NSNotification *)notification
{
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{
	NSToolbarItem *toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier: itemIdentifier] autorelease];
    
	if ([itemIdentifier isEqual: @"Startstop"]) {
		startstopToolbarItem = toolbarItem;
		[toolbarItem setTarget:self];
		[toolbarItem setAction:@selector(clickedStartStopTimer:)];
		[self updateStartStopState];
    }
	
	if ([itemIdentifier isEqual: @"AddProject"]) {
		[toolbarItem setLabel:@"New project"];
		[toolbarItem setPaletteLabel:@"New project"];
		[toolbarItem setToolTip:@"New project"];
		[toolbarItem setImage: addProjectToolImage];
		[toolbarItem setTarget:self];
		[toolbarItem setAction:@selector(clickedAddProject:)];
    }
	
	if ([itemIdentifier isEqual: @"AddTask"]) {
		[toolbarItem setLabel:@"New task"];
		[toolbarItem setPaletteLabel:@"New task"];
		[toolbarItem setToolTip:@"New task"];
		[toolbarItem setImage: addTaskToolImage];
		[toolbarItem setTarget:self];
		[toolbarItem setAction:@selector(clickedAddTask:)];
    }
    	
	if ([itemIdentifier isEqual: @"Day"]) {
		[toolbarItem setLabel:@"Day"];
		[toolbarItem setPaletteLabel:@"Day"];
		[toolbarItem setToolTip:@"Filter Day"];
//		[toolbarItem setImage: addTaskToolImage];
		[toolbarItem setTarget:self];
		[toolbarItem setAction:@selector(clickedFilterDay:)];
    }

	if ([itemIdentifier isEqual: @"Week"]) {
		[toolbarItem setLabel:@"Week"];
		[toolbarItem setPaletteLabel:@"Week"];
		[toolbarItem setToolTip:@"Filter Week"];
//		[toolbarItem setImage: addTaskToolImage];
		[toolbarItem setTarget:self];
		[toolbarItem setAction:@selector(clickedFilterWeek:)];
    }

	if ([itemIdentifier isEqual: @"Month"]) {
		[toolbarItem setLabel:@"Month"];
		[toolbarItem setPaletteLabel:@"Month"];
		[toolbarItem setToolTip:@"Filter Month"];
//		[toolbarItem setImage: addTaskToolImage];
		[toolbarItem setTarget:self];
		[toolbarItem setAction:@selector(clickedFilterMonth:)];
    }

	if ([itemIdentifier isEqual: @"PickDate"]) {
		[toolbarItem setLabel:@"PickDate"];
		[toolbarItem setPaletteLabel:@"PickDate"];
		[toolbarItem setToolTip:@"PickDate to filter"];
//		[toolbarItem setImage: addTaskToolImage];
		[toolbarItem setTarget:self];
		[toolbarItem setAction:@selector(clickedFilterPickDate:)];
		_tbPickDateItem = toolbarItem;
    }
    
    return toolbarItem;
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar
{
	return [NSArray arrayWithObjects: @"Startstop", NSToolbarSeparatorItemIdentifier, @"AddProject", @"AddTask", 
			NSToolbarSeparatorItemIdentifier, @"Day", @"Week", @"Month", @"PickDate", nil];
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar
{
	return [NSArray arrayWithObjects: @"Startstop", NSToolbarSeparatorItemIdentifier, @"AddProject", @"AddTask", 
			NSToolbarSeparatorItemIdentifier, @"Day", @"Week", @"Month", @"PickDate", nil];
}

- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar
{
	return nil;
}

- (void)awakeFromNib
{

	defaults = [NSUserDefaults standardUserDefaults];
	
	NSData *theData=[[NSUserDefaults standardUserDefaults] dataForKey:@"ProjectTimes"];
	if (theData != nil) {
		_projects = (NSMutableArray *)[[NSMutableArray arrayWithArray: [NSKeyedUnarchiver unarchiveObjectWithData:theData]] retain];
		[_metaProject setProjects:_projects];
		[_metaTask setTasks:[_metaProject tasks]];
	}
	_projects_lastTask = [[NSMutableDictionary alloc] initWithCapacity:[_projects count]];
	
	//NSNumber *numTotalTime = [defaults objectForKey: @"TotalTime"];
	
	/*NSZone *menuZone = [NSMenu menuZone];
	NSMenu *m = [[NSMenu allocWithZone:menuZone] init];

	startStopMenuItem = (NSMenuItem *)[m addItemWithTitle:@"Start" action:@selector(clickedStartStopTimer:) keyEquivalent:@""];
	[startStopMenuItem setTarget:self];
	[startStopMenuItem setTag:1];*/

	/*if ([preferences isGrowlRunning]) {
		[tempMenuItem setTitle:kRestartGrowl];
		[tempMenuItem setToolTip:kRestartGrowlTooltip];
	} else {
		[tempMenuItem setToolTip:kStartGrowlTooltip];
	}

	tempMenuItem = (NSMenuItem *)[m addItemWithTitle:kStopGrowl action:@selector(stopGrowl:) keyEquivalent:@""];
	[tempMenuItem setTag:2];
	[tempMenuItem setTarget:self];
	[tempMenuItem setToolTip:kStopGrowlTooltip];

	tempMenuItem = (NSMenuItem *)[m addItemWithTitle:kStopGrowlMenu action:@selector(terminate:) keyEquivalent:@""];
	[tempMenuItem setTag:5];
	[tempMenuItem setTarget:NSApp];
	[tempMenuItem setToolTip:kStopGrowlMenuTooltip];

	[m addItem:[NSMenuItem separatorItem]];

	tempMenuItem = (NSMenuItem *)[m addItemWithTitle:kSquelchMode action:@selector(squelchMode:) keyEquivalent:@""];
	[tempMenuItem setTarget:self];
	[tempMenuItem setTag:4];
	[tempMenuItem setToolTip:kSquelchModeTooltip];

	NSMenu *displays = [[NSMenu allocWithZone:menuZone] init];
	NSString *name;
	NSEnumerator *displayEnumerator = [[[GrowlPluginController controller] allDisplayPlugins] objectEnumerator];
	while ((name = [displayEnumerator nextObject])) {
		tempMenuItem = (NSMenuItem *)[displays addItemWithTitle:name action:@selector(defaultDisplay:) keyEquivalent:@""];
		[tempMenuItem setTarget:self];
		[tempMenuItem setTag:3];
	}
	tempMenuItem = (NSMenuItem *)[m addItemWithTitle:kDefaultDisplay action:NULL keyEquivalent:@""];
	[tempMenuItem setTarget:self];
	[tempMenuItem setSubmenu:displays];
	[displays release];
	[m addItem:[NSMenuItem separatorItem]];

	tempMenuItem = (NSMenuItem *)[m addItemWithTitle:kOpenGrowlPreferences action:@selector(openGrowlPreferences:) keyEquivalent:@""];
	[tempMenuItem setTarget:self];
	[tempMenuItem setToolTip:kOpenGrowlPreferencesTooltip];*/


	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength] retain];
	
	[statusItem setTarget: self];
	[statusItem setAction: @selector (clickedStartStopTimer:)];

	NSBundle *bundle = [NSBundle mainBundle];

	playItemImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"playitem" ofType:@"png"]];
	playItemHighlightImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"playitem_hl" ofType:@"png"]];
	stopItemImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"stopitem" ofType:@"png"]];
	stopItemHighlightImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"stopitem_hl" ofType:@"png"]];

	playToolImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"playtool" ofType:@"png"]];
	stopToolImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"stoptool" ofType:@"png"]];
	addTaskToolImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"addtasktool" ofType:@"png"]];
	addProjectToolImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"addprojecttool" ofType:@"png"]];

	//[statusItem setMenu:m]; // retains m
	[statusItem setToolTip:@"Time Tracker"];
	[statusItem setHighlightMode:NO];

	//[m release];		
	
	NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier: @"TimeTrackerToolbar"];
	[toolbar setDelegate: self];
	[mainWindow setToolbar: toolbar];	

	[self updateStartStopState];
	[self updateProminentDisplay];
	
	[tvWorkPeriods setTarget: self];
	[tvWorkPeriods setDoubleAction: @selector(doubleClickWorkPeriod:)];
	
	[tvProjects reloadData];
}

- (TWorkPeriod*) workPeriodAtIndex:(int) index
{
	TWorkPeriod *wp = nil;
	
	int result = [self selectedWorkPeriodRow];
	TTask *task = [self taskForWorkTimeIndex:index timeIndex:&result];
	wp = [[task workPeriods] objectAtIndex:result];
	return wp;	
}

- (TWorkPeriod*) selectedWorkPeriod 
{
	return [[workPeriodController arrangedObjects] objectAtIndex:[tvWorkPeriods selectedRow]];
//	return [self workPeriodAtIndex:[self selectedWorkPeriodRow]];
}

- (IBAction)okClicked:(id) sender
{
	[NSApp endSheet:panelEditWorkPeriod returnCode:NSOKButton];
}

- (IBAction)cancelClicked:(id) sender
{
	[NSApp endSheet:panelEditWorkPeriod returnCode:NSCancelButton];
}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
	if (sheet == panelPickFilterDate) {
		[_filterDate release];
		_filterDate = nil;
		if (returnCode == NSOKButton) {			
			_filterDate = [[dtpFilterDate dateValue] retain];
			[_tbPickDateItem setLabel:[_dateFormatter stringFromDate:_filterDate]];
		} else {
			[_tbPickDateItem setLabel:@"Pick Date"];
			[workPeriodController setFilterPredicate:nil];
		}
	} else {
		if (returnCode == NSOKButton) {
			[self clickedChangeWorkPeriod: nil];
		}
	}
	// hide the window
	[sheet orderOut:nil];
}

- (void) doubleClickWorkPeriod: (id) sender
{
	// assert _selProject != nil
	// assert _selTask != nil
	TWorkPeriod *wp = [self selectedWorkPeriod];
	[dtpEditWorkPeriodStartTime setDateValue: [wp startTime]];
	[dtpEditWorkPeriodEndTime setDateValue: [wp endTime]];
	[dtpEditWorkPeriodComment setString: [[wp comment] string]];
/*	[panelEditWorkPeriod makeKeyAndOrderFront: self];
	[NSApp runModalForWindow: panelEditWorkPeriod];
*/
	[NSApp beginSheet:panelEditWorkPeriod modalForWindow:mainWindow modalDelegate:self 
			didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (IBAction)clickedChangeWorkPeriod:(id)sender
{
	// assert _selProject != nil
	// assert _selTask != nil
	TWorkPeriod *wp = [self selectedWorkPeriod];
	[wp setStartTime: [dtpEditWorkPeriodStartTime dateValue]];
	[wp setEndTime: [dtpEditWorkPeriodEndTime dateValue]];
	[wp setComment: [[[NSAttributedString alloc] initWithString:[dtpEditWorkPeriodComment string]] autorelease]];
	[_selTask updateTotalTime];
	[_selProject updateTotalTime];
	[tvProjects reloadData];
	[tvTasks reloadData];
	[tvWorkPeriods reloadData];
	[NSApp stopModal];
	[panelEditWorkPeriod orderOut: self];
}

- (void) showIdleNotification
{
		[NSApp activateIgnoringOtherApps: YES];
		[NSApp runModalForWindow: panelIdleNotification];
		[panelIdleNotification orderOut: self];
}

- (void) timerFunc: (NSTimer *) atimer
{	
	if ([panelIdleNotification isVisible]) {
		return;
	}
	// assert timer != nil
	// assert timer == atimer
	if (timer != atimer) return;
	
	// determine if the computer was on standby
	NSDate *lastEndTime = [_curWorkPeriod endTime];
	NSDate *curTime = [NSDate date];
	if ([curTime timeIntervalSinceDate:lastEndTime] > 60) {
		[timer setFireDate: [NSDate distantFuture]];
		// time jumped by 60 seconds, probably the computer was on standby
		[_lastNonIdleTime release];
		_lastNonIdleTime = [lastEndTime retain];
		[self showIdleNotification];
		return;
	}
	[_curWorkPeriod setEndTime: curTime];
	[_curTask updateTotalTime];
	[_curProject updateTotalTime];
	[tvProjects reloadData];
	[tvTasks reloadData];
	[tvWorkPeriods reloadData];
	int idleTime = [self idleTime];
	if (idleTime == 0) {
		[_lastNonIdleTime release];
		_lastNonIdleTime = [[NSDate date] retain];
	}
	if (idleTime > 5 * 60) {
		[timer setFireDate: [NSDate distantFuture]];
		[self showIdleNotification];
	}
	
	[self updateProminentDisplay];
	
	if (timeSinceSave > 5 * 60) {
		[self saveData];
	} else {
		timeSinceSave++;
	}
}

- (void)windowWillClose:(NSNotification *)notification
{
	if ([notification object] == mainWindow)
		[NSApp terminate: self];
	if ([notification object] == panelEditWorkPeriod)
		[NSApp stopModal];
}

- (NSString*)serializeData 
{
	NSMutableString *result = [NSMutableString stringWithString:@"\"Project\";\"Task\";\"Date\";\"Start\";\"End\";\"Duration\";\"Comment\"\n"];
	NSEnumerator *enumerator = [_projects objectEnumerator];
	id anObject;
 
	while (anObject = [enumerator nextObject])
	{
		[result appendString:[anObject serializeData]];
	}
	return result;
}

- (void)saveData
{
	NSData *theData=[NSKeyedArchiver archivedDataWithRootObject:_projects];
	[[NSUserDefaults standardUserDefaults] setObject:theData forKey:@"ProjectTimes"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	timeSinceSave = 0;
	
	NSString *data = [self serializeData];
	[data writeToFile:[@"~/times.csv" stringByExpandingTildeInPath] atomically:YES];
/*	NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:@"data.txt"];
	[fileHandle writ]
	/*
	NSData *xmlData = [NSPropertyListSerialization dataFromPropertyList:_projects 
		format:kCFPropertyListXMLFormat_v1_0 errorDescription:&error];
	[xmlData writeToFile:@"testdata.xml" atomically:YES];
//	[fileHandle file]*/
}



- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
	if (timer != nil)
		[self stopTimer];
	[self saveData];
	return NSTerminateNow;
}


- (void)tableView:(NSTableView *)aTableView willDisplayCell:(id)aCell forTableColumn:(NSTableColumn *)aTableColumn row:(unsigned)rowIndex {
	if (_normalCol == nil) {
		_normalCol = [[aCell textColor] retain];
		_highlightCol = [[_normalCol highlightWithLevel:0.5] retain];
	}
	if (aTableView != tvWorkPeriods) {
		return;
	}
	TWorkPeriod *wp = [self workPeriodAtIndex:rowIndex];
	if (wp == _curWorkPeriod) {
		[aCell setTextColor:_highlightCol];
	}
	else {
		[aCell setTextColor:_normalCol];
	}
}

- (int)numberOfRowsInTableView:(NSTableView *)tableView
{
	if (tableView == tvProjects) {
		return [_projects count] + 1;
	}
	if (tableView == tvTasks) {
		if (_selProject == nil)
			return 0;
		else
			return [[_selProject tasks] count] + 1;
	}
	if (tableView == tvWorkPeriods) {
		if (_selTask == nil)
			return 0;
		else
			return [[_selTask workPeriods] count];
	}
	return 0;
}
- (TTask*) taskForWorkTimeIndex: (int) rowIndex timeIndex:(int*)resultIndex {
	NSEnumerator *enumerator = [[_selProject tasks] objectEnumerator];
	id aTask;
	*resultIndex = rowIndex;
	
	while (aTask = [enumerator nextObject])
	{
		int count = [[aTask workPeriods] count];
		if (count > *resultIndex) {
			break;
		}
		*resultIndex -= count;
	}
	return aTask;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)rowIndex
{
	if (tableView == tvProjects) {
		id project = nil;
		if (rowIndex == 0) {
			project = _metaProject;
		} else {
			project = [_projects objectAtIndex: rowIndex - 1];
		}
		if ([[tableColumn identifier] isEqualToString: @"ProjectName"]) {
			return [project name];
		}
		if ([[tableColumn identifier] isEqualToString: @"TotalTime"]) {
			return [TimeIntervalFormatter secondsToString: [project totalTime]];
		}
	}
	
	if (tableView == tvTasks) {
		id<ITask> task = nil;
		if (rowIndex == 0) {
			task = _metaTask;
		} else {
			task = [[_selProject tasks] objectAtIndex: rowIndex - 1];
		}
		if ([[tableColumn identifier] isEqualToString: @"TaskName"]) {
			return [task name];
		}
		if ([[tableColumn identifier] isEqualToString: @"TotalTime"]) {
			return [TimeIntervalFormatter secondsToString: [task totalTime]];
		}
	}
	
	if (tableView == tvWorkPeriods) {
		TWorkPeriod *period = nil;
		
		// find out which task contains the correct period
		if (_selProject == nil) 
			// should not happen
			return nil;
		int workIndex = rowIndex;
		
		id aTask;
		aTask = [self taskForWorkTimeIndex:rowIndex timeIndex:&workIndex];
		if ([[tableColumn identifier] isEqualToString:@"Task"]) {
			return [aTask name];
		}
		period = [[aTask workPeriods] objectAtIndex:workIndex];
		
		if ([[tableColumn identifier] isEqualToString: @"Date"]) {
			// assert _dateFormatter != nil
			return [_dateFormatter stringFromDate:[period startTime]];
		}
		if ([[tableColumn identifier] isEqualToString: @"StartTime"]) {
			return [[period startTime] 
				descriptionWithCalendarFormat: @"%H:%M:%S"
				timeZone: nil locale: nil];
		}
		if ([[tableColumn identifier] isEqualToString: @"EndTime"]) {
			NSDate *endTime = [period endTime];
			if (endTime == nil)
				return @"";
			else
				return [endTime 
					descriptionWithCalendarFormat: @"%H:%M:%S"
					timeZone: nil locale: nil];
		}
		if ([[tableColumn identifier] isEqualToString: @"Duration"]) {
			return [TimeIntervalFormatter secondsToString: [period totalTime]];
		}
		if ([[tableColumn identifier] isEqualToString:@"Comment"]) {
			return [period comment];
		}
	}
	
	return nil;
}

- (IBAction)clickedAddProject:(id)sender
{
	[self createProject];

	int index = [_projects count] - 1;
	[tvProjects editColumn:[tvProjects columnWithIdentifier:@"ProjectName"] row:index withEvent:nil select:YES];
}

- (void)createProject
{
	TProject *proj = [TProject new];
	[_projects addObject: proj];
	[tvProjects reloadData];
	int index = [_projects count];
	[tvProjects selectRowIndexes:[NSIndexSet indexSetWithIndex:index] byExtendingSelection:NO];
	[mainWindow makeFirstResponder:tvProjects];
}

- (IBAction)clickedAddTask:(id)sender
{
	[self createTask];

	int index = [[_selProject tasks] count] - 1;
	[tvTasks editColumn:[tvTasks columnWithIdentifier:@"TaskName"] row:index withEvent:nil select:YES];
}

-(NSDate*) determineFilterStartDate 
{
	if (_filterDate == nil) 
	{
		return nil;
	}
	[filterStartDate release];
	filterStartDate = nil;
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *comps = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:_filterDate];
	filterStartDate = [[cal dateFromComponents:comps] retain];
	return filterStartDate;
}

- (IBAction)clickedFilterDay:(id)sender 
{
	NSLog(@"Day filter clicked");
	[self determineFilterStartDate];
	filterEndDate = [[[NSDate alloc] initWithTimeInterval:60*60*24 sinceDate:filterStartDate] autorelease];
	NSLog(@"startTime >= %@ AND endTime <= %@", filterStartDate, filterEndDate);
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"startTime >= %@ AND endTime <= %@", filterStartDate, filterEndDate];
	[workPeriodController setFilterPredicate:pred];
	NSLog(@"day filter done");
}

- (IBAction)clickedFilterWeek:(id)sender 
{
	NSLog(@"week filter clicked %@", _filterDate);
	[self determineFilterStartDate];
	NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
	[comps setWeek:1];
	filterEndDate = [[[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:filterStartDate options:0] retain];
	NSLog(@"startTime >= %@ AND endTime <= %@", filterStartDate, filterEndDate);
	NSLog(@"objects %@", [workPeriodController content]);
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"startTime >= %@ AND endTime <= %@", filterStartDate, filterEndDate];
	NSLog(@"afterobjects %@", [workPeriodController content]);
	[workPeriodController setFilterPredicate:pred];
	NSLog(@"Week filter done");
}

- (IBAction)clickedFilterMonth:(id)sender 
{
	NSLog(@"Month filter clicked %@", _filterDate);
	[self determineFilterStartDate];
	NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
	[comps setMonth:1];
	filterEndDate = [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:filterStartDate options:0];
	NSLog(@"startTime >= %@ AND endTime <= %@", filterStartDate, filterEndDate);
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"startTime >= %@ AND endTime <= %@", filterStartDate, filterEndDate];
	[workPeriodController setFilterPredicate:pred];
	NSLog(@"month filter done");

}

- (IBAction)clickedFilterPickDate:(id)sender 
{
	NSLog(@"Pick Date filter clicked");
	[dtpFilterDate setDateValue:[NSDate date]];
	[NSApp beginSheet:panelPickFilterDate modalForWindow:mainWindow modalDelegate:self 
			didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
}


- (IBAction)clickedFilterDateOk:(id) sender
{
	[NSApp endSheet:panelPickFilterDate returnCode:NSOKButton];
}

- (IBAction)clickedFilterDateCancel:(id)sender 
{
	[NSApp endSheet:panelPickFilterDate returnCode:NSCancelButton];
//	[_tbPickDateItem setLabel:@"Pick Date"];

}

- (void)createTask
{
	// assert _selProject != nil
	if (_selProject == nil) return;
	
	TTask *task = [TTask new];
	[(TProject*)_selProject addTask: task];
	[tvTasks reloadData];
	int index = [[_selProject tasks] count];
	[tvTasks selectRowIndexes:[NSIndexSet indexSetWithIndex:index] byExtendingSelection:NO];
	[mainWindow makeFirstResponder:tvTasks];
}

- (void)selectAndUpdateMetaTask {
	[_metaTask setTasks:[_selProject tasks]];
	_selTask = _metaTask;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
	if ([notification object] == tvProjects) {
		// Save the last task for the old project
		if (_selProject != nil) {
			NSNumber *index = [NSNumber numberWithInt:[self selectedTaskRow]];
			if ([self selectedTaskRow] >= 0) {
				[_projects_lastTask setObject:index forKey:[_selProject name]];
			}
		}
	
		// Update the new selection
		if ([self selectedProjectRow] == -2) {
			_selProject = nil;
		} else if ([self selectedProjectRow] == -1) {
			_selProject = _metaProject;
		} else {
			_selProject = [_projects objectAtIndex: [self selectedProjectRow]];
		}

		[tvTasks deselectAll: self];
		[tvTasks reloadData];
		
		if (_selProject != nil && [[_selProject tasks] count] > 0) {
			NSNumber *lastTask = [_projects_lastTask objectForKey:[_selProject name]];
			if (lastTask == nil || [lastTask intValue] == -1) {
				[tvTasks selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
			} else {
				[tvTasks selectRowIndexes:[NSIndexSet indexSetWithIndex:[lastTask intValue]] byExtendingSelection:NO];
			}
		}
		
		[self updateProminentDisplay];
	}
	
	if ([notification object] == tvTasks) {
		if ([self selectedTaskRow] == -2) {
			_selTask = nil;
		} else if ([self selectedTaskRow] == -1) {
			[self selectAndUpdateMetaTask];
		} else {
			// assert _selProject != nil
			_selTask = [[_selProject tasks] objectAtIndex: [self selectedTaskRow]];
		}
		NSLog(@"Updating workperiods...........");
		[workPeriodController setContent:[_selTask workPeriods]];
		[tvWorkPeriods reloadData];
		[self updateProminentDisplay];
	}

}

- (void)tableView:(NSTableView *)tableView 
	setObjectValue:(id)obj 
	forTableColumn:(NSTableColumn *)tableColumn 
	row:(int)rowIndex
{
	if (tableView == tvProjects) {
		if ([[tableColumn identifier] isEqualToString: @"ProjectName"] && [_selProject isKindOfClass:[TProject class]]) {
			[(TProject*)_selProject setName: obj];
		}
	}
	if (tableView == tvTasks) {
		if ([[tableColumn identifier] isEqualToString: @"TaskName"] && [_selTask isKindOfClass:[TTask class]]) {
			[(TTask*)_selTask setName: obj];
		}
	}
}

- (IBAction)clickedDelete:(id)sender
{
	if ([mainWindow firstResponder] == tvWorkPeriods) {
		// assert _selTask != nil
		// assert _selProject != nil
		TWorkPeriod *selWorkPeriod = [self selectedWorkPeriod];
		// assert _selWorkPeriod != nil
		if (selWorkPeriod == _curWorkPeriod) {
			[self stopTimer];
		}
		
		[_selTask removeWorkPeriod:selWorkPeriod];
		[_selTask updateTotalTime];
		[_selProject updateTotalTime];
		[tvWorkPeriods deselectAll: self];
		[tvWorkPeriods reloadData];
		[tvTasks reloadData];
		[tvProjects reloadData];
	}
	if ([mainWindow firstResponder] == tvTasks) {
		if ([_selProject isKindOfClass: [TProject class]]) {
			if ([_selTask isKindOfClass:[TMetaTask class]]) {
				return;
			}
			TProject *project = (TProject*) _selProject;
			// assert _selTask != nil
			// assert _selProject != nil
			if (_selTask == _curTask) {
				[self stopTimer];
			}
			TTask *delTask = (TTask*)_selTask;
			[tvTasks deselectAll: self];
			[[project tasks] removeObject: delTask];
			[project updateTotalTime];
			[tvTasks reloadData];
			[tvProjects reloadData];
		}
	}
	if ([mainWindow firstResponder] == tvProjects) {
		if ([_selProject isKindOfClass:[TMetaProject class]]) {
			return;
		}
		// assert _selProject != nil
		if (_selProject == _curProject) {
			[self stopTimer];
		}
		TProject *delProject = (TProject*)_selProject;
		[tvProjects deselectAll: self];
		[_projects removeObject: delProject];
		[tvProjects reloadData];
	}
}

- (int)idleTime 
{
  mach_port_t masterPort;
  io_iterator_t iter;
  io_registry_entry_t curObj;
  int res = 0;

  IOMasterPort(MACH_PORT_NULL, &masterPort);
  
  IOServiceGetMatchingServices(masterPort,
                 IOServiceMatching("IOHIDSystem"),
                 &iter);
  if (iter == 0) {
    return 0;
  }
  
  curObj = IOIteratorNext(iter);

  if (curObj == 0) {
    return 0;
  }

  CFMutableDictionaryRef properties = 0;
  CFTypeRef obj;

  if (IORegistryEntryCreateCFProperties(curObj, &properties,
                   kCFAllocatorDefault, 0) ==
      KERN_SUCCESS && properties != NULL) {

    obj = CFDictionaryGetValue(properties, CFSTR("HIDIdleTime"));
    CFRetain(obj);
  } else {
    obj = NULL;
  }

  if (obj) {
    uint64_t tHandle;

    CFTypeID type = CFGetTypeID(obj);

    if (type == CFDataGetTypeID()) {
      CFDataGetBytes((CFDataRef) obj,
           CFRangeMake(0, sizeof(tHandle)),
           (UInt8*) &tHandle);
    }  else if (type == CFNumberGetTypeID()) {
      CFNumberGetValue((CFNumberRef)obj,
             kCFNumberSInt64Type,
             &tHandle);
    } else {
      return 0;
    }

    CFRelease(obj);

    // essentially divides by 10^9
    tHandle >>= 30;
	res = tHandle;
  } else {
	}

  /* Release our resources */
  IOObjectRelease(curObj);
  IOObjectRelease(iter);
  CFRelease((CFTypeRef)properties);

  return res;
}

- (IBAction)clickedCountIdleTimeYes:(id)sender
{
	// update the current end time in order not to let the
	// standby timer go off
	[_curWorkPeriod setEndTime: [NSDate date]];

	// assert timer != nil
	[timer setFireDate: [NSDate dateWithTimeIntervalSinceNow: 1]];
	[NSApp stopModal];
}

- (BOOL) validateUserInterfaceItem:(id)anItem
{
	if ([anItem action] == @selector(clickedStartStopTimer:)) {
		if (timer != nil) return YES;
		if (_selTask != nil && [_selTask isKindOfClass:[TTask class]]) return YES;
		return NO;
	} else if ([anItem action] == @selector(clickedAddProject:)) {
		return YES;
	} else if ([anItem action] == @selector(clickedAddTask:)) {
		if (_selProject != nil && [_selProject isKindOfClass:[TProject class]]) {
			return YES;
		}
		return NO;
	}
	return YES;
}

- (void)updateStartStopState
{
	if (timer == nil) {
		// Timer is stopped: show the Start button
		if (startstopToolbarItem != nil) {
			[startstopToolbarItem setLabel:@"Start"];
			[startstopToolbarItem setPaletteLabel:@"Start"];
			[startstopToolbarItem setToolTip:@"Start timer"];
			[startstopToolbarItem setImage: playToolImage];
		}
		
		// assert statusItem != nil
		[statusItem setImage:playItemImage];
		[statusItem setAlternateImage:playItemHighlightImage];
		
		// assert startMenuItem != nil
		[startMenuItem setTitle:@"Start Timer"];
	} else {
		if (startstopToolbarItem != nil) {
			[startstopToolbarItem setLabel:@"Stop"];
			[startstopToolbarItem setPaletteLabel:@"Stop"];
			[startstopToolbarItem setToolTip:@"Stop timer"];
			[startstopToolbarItem setImage: stopToolImage];
		}
		
		// assert statusItem != nil
		[statusItem setImage:stopItemImage];
		[statusItem setAlternateImage:stopItemHighlightImage];
		
		// assert startMenuItem != nil
		[startMenuItem setTitle:@"Stop Timer"];
	}
	
}

- (void)updateProminentDisplay
{
	if (_curTask != nil) {
		NSString *s = [[_curTask name] stringByAppendingString:@" - "];
		s = [s stringByAppendingString:[TimeIntervalFormatter secondsToString:[_curTask totalTime]]];
		[tfActiveTask setStringValue:s];
		[tfActiveTask setTextColor:[NSColor blackColor]];
	} else if (_selTask != nil) {
		NSString *s = [[_selTask name] stringByAppendingString:@" - "];
		s = [s stringByAppendingString:[TimeIntervalFormatter secondsToString:[_selTask totalTime]]];
		[tfActiveTask setStringValue:s];
		[tfActiveTask setTextColor:[NSColor lightGrayColor]];
	} else {
		[tfActiveTask setStringValue:@"New Task - 00:00:00"];
		[tfActiveTask setTextColor:[NSColor lightGrayColor]];
	}

	if (_curProject != nil) {
		NSString *s = [[_curProject name] stringByAppendingString:@" - "];
		s = [s stringByAppendingString:[TimeIntervalFormatter secondsToString:[_curProject totalTime]]];
		[tfActiveProject setStringValue:s];
		[tfActiveProject setTextColor:[NSColor blackColor]];
	} else if (_selProject != nil) {
		NSString *s = [[_selProject name] stringByAppendingString:@" - "];
		s = [s stringByAppendingString:[TimeIntervalFormatter secondsToString:[_selProject totalTime]]];
		[tfActiveProject setStringValue:s];
		[tfActiveProject setTextColor:[NSColor lightGrayColor]];	
	} else {
		[tfActiveProject setStringValue:@"New Project - 00:00:00"];
		[tfActiveProject setTextColor:[NSColor lightGrayColor]];
	}
	
}

- (IBAction)clickedCountIdleTimeNo:(id)sender
{
	[NSApp stopModal];
	// assert _lastNonIdleTime != nil
	[self stopTimer:_lastNonIdleTime];
	[_lastNonIdleTime release];
	_lastNonIdleTime = nil;
}


@end
