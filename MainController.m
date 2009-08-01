#include <IOKit/IOKitLib.h>

#import "MainController.h"
#import "TTask.h"
#import "TProject.h"
#import "TimeIntervalFormatter.h"
#import "TWorkPeriod.h"

@interface MainController (PrivateMethods)
- (void)initializeTableViews;
@end

@implementation MainController

#define TOOLBAR_IDENTIFIER @"TimeTrackerToolbar"
#define TOOLBAR_ITEM_START_STOP @"Startstop"
#define TOOLBAR_ITEM_ADD_PROJECT @"AddProject"
#define TOOLBAR_ITEM_ADD_TASK @"AddTask"

#define PBOARD_TYPE_PROJECT_ROWS @"TIME_TRACKER_PROJECT_ROWS"
#define PBOARD_TYPE_TASK_ROWS @"TIME_TRACKER_TASK_ROWS"

#define TABLE_COLUMN_TOTAL_TIME @"TotalTime"
#define TABLE_COLUMN_PROJECT_NAME @"ProjectName"
#define TABLE_COLUMN_TASK_NAME @"TaskName"
#define TABLE_COLUMN_DATE @"Date"
#define TABLE_COLUMN_START_TIME @"StartTime"
#define TABLE_COLUMN_END_TIME @"EndTime"
#define TABLE_COLUMN_DURATION @"Duration"

#define DATA_TYPE_CSV @"CSV"

- (id) init
{
  return [self initWithDocumentLoader:[[TTDocumentLoader alloc] init]];
}

- (id) initWithDocumentLoader:(TTDocumentLoader *)aDocumentLoader
{
  documentLoader = [aDocumentLoader retain];
  document = [documentLoader loadDocument];
  documentController = [self retain];
  timeProvider = [[TTTimeProvider alloc] init];
  timer = [[TTTimer alloc] initWithDelegate:self];
  return self;
}

- (void)dealloc
{
  [mainWindow release];
	[filterStartTime release];
	[filterEndTime release];
  if (documentController != self)
  {
    [documentController release];
  }
  [documentLoader release];
  [timeProvider release];
  [timer release];
	[super dealloc];
}

- (IBAction)clickedStartStopTimer:(id)sender
{
  if (![timer isRunning]) {
		[self startTimer];
	} else {
		[self stopTimer];
	}
}

- (void)startTimer
{
  if ([timer isRunning]) return;
	
	if (_selTask == nil)
	{
		[self createTask];
	}
	// assert _selProject != nil
	// assert _selTask != nil
	if (_selTask == nil) return;
	
  [timer start];
	
	[self updateStartStopState];
	
	_curWorkPeriod = [TWorkPeriod new];
	[_curWorkPeriod setStartTime: [timer currentTime]];
	[_curWorkPeriod setEndTime: [timer currentTime]];
	
	[_selTask addWorkPeriod: _curWorkPeriod];
	[tvWorkPeriods reloadData];	
	_curProject = _selProject;
	_curTask = _selTask;
	
	// assert [timer isRunning]
	// assert _curProject != nil
	// assert _curTask != nil
}

- (void)stopTimer
{
  if ( ![timer isRunning]) return;
  
  [timer stop];
	
	_curWorkPeriod = nil;
	_curProject = nil;
	_curTask = nil;
	
	[self saveData];
	
	[self updateStartStopState];
	
	[tvProjects reloadData];
	[tvTasks reloadData];
	[tvWorkPeriods reloadData];
	
	// assert ![timer isRunning]
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
    
	if ([itemIdentifier isEqual:TOOLBAR_ITEM_START_STOP]) {
		startstopToolbarItem = toolbarItem;
		[toolbarItem setTarget:self];
		[toolbarItem setAction:@selector(clickedStartStopTimer:)];
		[self updateStartStopState];
    }
	
	if ([itemIdentifier isEqual:TOOLBAR_ITEM_ADD_PROJECT]) {
		[toolbarItem setLabel:NSLocalizedString(@"New project", @"Toolbar button label")];
		[toolbarItem setPaletteLabel:NSLocalizedString(@"New project", nil)];
		[toolbarItem setToolTip:NSLocalizedString(@"New project", nil)];
		[toolbarItem setImage: addProjectToolImage];
		[toolbarItem setTarget:self];
		[toolbarItem setAction:@selector(clickedAddProject:)];
    }
	
	if ([itemIdentifier isEqual:TOOLBAR_ITEM_ADD_TASK]) {
		[toolbarItem setLabel:NSLocalizedString(@"New task", "Toolbar button label")];
		[toolbarItem setPaletteLabel:NSLocalizedString(@"New task", nil)];
		[toolbarItem setToolTip:NSLocalizedString(@"New task", nil)];
		[toolbarItem setImage: addTaskToolImage];
		[toolbarItem setTarget:self];
		[toolbarItem setAction:@selector(clickedAddTask:)];
    }
    
    return toolbarItem;
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar
{
	return [NSArray arrayWithObjects:
			TOOLBAR_ITEM_START_STOP, NSToolbarSeparatorItemIdentifier,
			TOOLBAR_ITEM_ADD_PROJECT, TOOLBAR_ITEM_ADD_TASK, nil];
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar
{
	return [NSArray arrayWithObjects:
			TOOLBAR_ITEM_START_STOP, NSToolbarSeparatorItemIdentifier,
			TOOLBAR_ITEM_ADD_PROJECT, TOOLBAR_ITEM_ADD_TASK, nil];
}

- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar
{
	return nil;
}

- (void)awakeFromNib
{
	defaults = [NSUserDefaults standardUserDefaults];
	
	_projects_lastTask = [[NSMutableDictionary alloc] initWithCapacity:[[document projects] count]];
	
	/*NSZone *menuZone = [NSMenu menuZone];
	NSMenu *m = [[NSMenu allocWithZone:menuZone] init];

	startStopMenuItem = (NSMenuItem *)[m addItemWithTitle:NSLocalizedString(@"Start", nil) action:@selector(clickedStartStopTimer:) keyEquivalent:@""];
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

	playItemImage = [[NSImage imageNamed:@"playitem.png"] retain];
	playItemHighlightImage = [[NSImage imageNamed:@"playitem_hl.png"] retain];
	stopItemImage = [[NSImage imageNamed:@"stopitem.png"] retain];
	stopItemHighlightImage = [[NSImage imageNamed:@"stopitem_hl.png"] retain];

	playToolImage = [[NSImage imageNamed:@"playtool.png"] retain];
	stopToolImage = [[NSImage imageNamed:@"stoptool.png"] retain];
	addTaskToolImage = [[NSImage imageNamed:@"addtasktool.png"] retain];
	addProjectToolImage = [[NSImage imageNamed:@"addprojecttool.png"] retain];

	//[statusItem setMenu:m]; // retains m
	[statusItem setToolTip:[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleNameKey]];
	[statusItem setHighlightMode:NO];

	//[m release];		
	
	NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:TOOLBAR_IDENTIFIER];
	[toolbar setDelegate: self];
	[mainWindow setToolbar: toolbar];	

	[self updateStartStopState];
	
	[self initializeTableViews];
}

- (void)initializeTableViews
{
	[tvWorkPeriods setTarget: self];
	[tvWorkPeriods setDoubleAction: @selector(doubleClickWorkPeriod:)];

	[tvProjects reloadData];

//	[tvProjects setDraggingSourceOperationMask:NSDragOperationMove forLocal:YES];
	[tvProjects registerForDraggedTypes:[NSArray arrayWithObjects:PBOARD_TYPE_PROJECT_ROWS, nil]];
	[tvTasks registerForDraggedTypes:[NSArray arrayWithObjects:PBOARD_TYPE_TASK_ROWS, nil]];
}

- (TWorkPeriod *)workPeriodAtIndex:(unsigned)index
{
  assert(_selTask != nil);
  if (filterStartTime == nil)
	{
		return [[_selTask workPeriods] objectAtIndex:index];
	}
	else
	{
		assert(filterEndTime != nil);
		return [[_selTask workPeriodsInRangeFrom:filterStartTime to:filterEndTime] objectAtIndex:index];
	}  
}

- (void)doubleClickWorkPeriod:(id)sender
{
  TWorkPeriod *wp = [documentController workPeriodAtIndex:[tvWorkPeriods selectedRow]];
	[dtpEditWorkPeriodStartTime setDateValue: [wp startTime]];
	[dtpEditWorkPeriodEndTime setDateValue: [wp endTime]];
	[panelEditWorkPeriod makeKeyAndOrderFront: self];
	[NSApp runModalForWindow: panelEditWorkPeriod];
}

- (IBAction)clickedChangeWorkPeriod:(id)sender
{
	// assert _selProject != nil
	// assert _selTask != nil
	TWorkPeriod *wp = [documentController workPeriodAtIndex: [tvWorkPeriods selectedRow]];
	[wp setStartTime: [dtpEditWorkPeriodStartTime dateValue]];
	[wp setEndTime: [dtpEditWorkPeriodEndTime dateValue]];
	[tvProjects reloadData];
	[tvTasks reloadData];
	[tvWorkPeriods reloadData];
	[NSApp stopModal];
	[panelEditWorkPeriod orderOut: self];
}

- (void)windowWillClose:(NSNotification *)notification
{
	if ([notification object] == mainWindow)
		[NSApp terminate: self];
	if ([notification object] == panelEditWorkPeriod)
		[NSApp stopModal];
}

- (void)saveData
{
  [documentLoader saveDocument:document];
	timeSinceSave = 0;
}

- (IBAction)actionExport:(id)sender
{
	NSSavePanel *sp;
	int savePanelResult;
	
	sp = [NSSavePanel savePanel];
	
	[sp setTitle:NSLocalizedString(@"Export", @"Title of the data export window")];
	[sp setNameFieldLabel:NSLocalizedString(@"Export to:", @"Label for the filename field in the data export window")];
	[sp setPrompt:NSLocalizedString(@"Export", nil)];
	
	[sp setRequiredFileType:@"csv"];
	
	NSString *defaultFileName = [NSString stringWithFormat:@"%@.csv", NSLocalizedString(@"Time Tracker Data", @"Default filename for exporting data")];
	savePanelResult = [sp runModalForDirectory:nil file:defaultFileName];
	
	if (savePanelResult == NSOKButton) {
		NSError *err;
		NSData *data = [[document dataOfType:DATA_TYPE_CSV error:&err] retain];
		[data writeToFile:[sp filename] atomically:YES];
		[data release];
	}
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
  if ([timer isRunning])
		[self stopTimer];
	[self saveData];
	return NSTerminateNow;
}

- (int)numberOfRowsInTableView:(NSTableView *)tableView
{
	if (tableView == tvProjects) {
		return [[document projects] count];
	}
	if (tableView == tvTasks) {
		if (_selProject == nil)
			return 0;
		else
			return [[_selProject tasks] count];
	}
	if (tableView == tvWorkPeriods) {
		if (_selTask == nil)
		{
			return 0;
		}
		else
		{
			return [self countOfWorkPeriodsForTask:_selTask];
		}
	}
	return 0;
}

- (NSTimeInterval)totalTimeForProject:(TProject *)project
{
	if (filterStartTime == nil)
	{
		return [project totalTime];		
	}
	else
	{
		assert(filterEndTime != nil);
		return [project totalTimeInRangeFrom:filterStartTime to:filterEndTime];
	}
}

- (NSTimeInterval)totalTimeForTask:(TTask *)task
{
	if (filterStartTime == nil)
	{
		return [task totalTime];
	}
	else
	{
		assert(filterEndTime != nil);
		return [task totalTimeInRangeFrom:filterStartTime to:filterEndTime];
	}
}

- (int)countOfWorkPeriodsForTask:(TTask *)task
{
	if (filterStartTime == nil)
	{
		return [[task workPeriods] count];
	}
	else
	{
		assert(filterEndTime != nil);
		return [[task workPeriodsInRangeFrom:filterStartTime to:filterEndTime] count];
	}
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)rowIndex
{
	if (tableView == tvProjects) {
		TProject *p = [[document projects] objectAtIndex:rowIndex];
		if ([[tableColumn identifier] isEqualToString:TABLE_COLUMN_PROJECT_NAME]) {
			return [p name];
		}
		if ([[tableColumn identifier] isEqualToString:TABLE_COLUMN_TOTAL_TIME]) {
			return [TimeIntervalFormatter secondsToString:[self totalTimeForProject:p]];
		}
	}
	
	if (tableView == tvTasks) {
		TTask *t = [[_selProject tasks] objectAtIndex:rowIndex];
		if ([[tableColumn identifier] isEqualToString:TABLE_COLUMN_TASK_NAME]) {
			return [t name];
		}
		if ([[tableColumn identifier] isEqualToString:TABLE_COLUMN_TOTAL_TIME]) {
			return [TimeIntervalFormatter secondsToString:[self totalTimeForTask:t]];
		}
	}
	
	if (tableView == tvWorkPeriods) {
		TWorkPeriod *wp = [documentController workPeriodAtIndex:rowIndex];
		
		if ([[tableColumn identifier] isEqualToString:TABLE_COLUMN_DATE]) {
			return [[wp startTime] 
				descriptionWithCalendarFormat: @"%m/%d/%Y"
				timeZone: nil locale: nil];
		}
		if ([[tableColumn identifier] isEqualToString:TABLE_COLUMN_START_TIME]) {
			return [[wp startTime] 
				descriptionWithCalendarFormat: @"%H:%M:%S"
				timeZone: nil locale: nil];
		}
		if ([[tableColumn identifier] isEqualToString:TABLE_COLUMN_END_TIME]) {
			NSDate *endTime = [wp endTime];
			if (endTime == nil)
				return @"";
			else
				return [endTime 
					descriptionWithCalendarFormat: @"%H:%M:%S"
					timeZone: nil locale: nil];
		}
		if ([[tableColumn identifier] isEqualToString:TABLE_COLUMN_DURATION]) {
			return [TimeIntervalFormatter secondsToString: [wp totalTime]];
		}
	}
	
	return nil;
}

- (void)createProject
{
	TProject *proj = [TProject new];
	[document addProject:proj];
	[tvProjects reloadData];
	int index = [[document projects] count] - 1;
	[tvProjects selectRowIndexes:[NSIndexSet indexSetWithIndex:index] byExtendingSelection:NO];
	_selProject = proj;
}

- (IBAction)clickedAddProject:(id)sender
{
	TProject *proj = [TProject new];
	[document addProject:proj];
	[tvProjects reloadData];
	int index = [[document projects] count] - 1;
	[tvProjects selectRowIndexes:[NSIndexSet indexSetWithIndex:index] byExtendingSelection:NO];
	[tvProjects editColumn:[tvProjects columnWithIdentifier:TABLE_COLUMN_PROJECT_NAME] row:index withEvent:nil select:YES];
}

- (void)createTask
{
	if (_selProject == nil)
	{
		[self createProject];
	}
	TTask *task = [TTask new];
	[_selProject addTask:task];
	[tvTasks reloadData];
	int index = [[_selProject tasks] count] - 1;
	[tvTasks selectRowIndexes:[NSIndexSet indexSetWithIndex:index] byExtendingSelection:NO];
	_selTask = task;
}

- (IBAction)clickedAddTask:(id)sender
{
	// assert _selProject != nil
	if (_selProject == nil) return;
	
	TTask *task = [TTask new];
	[_selProject addTask: task];
	[tvTasks reloadData];
	int index = [[_selProject tasks] count] - 1;
	[tvTasks selectRowIndexes:[NSIndexSet indexSetWithIndex:index] byExtendingSelection:NO];
	[tvTasks editColumn:[tvTasks columnWithIdentifier:TABLE_COLUMN_TASK_NAME] row:index withEvent:nil select:YES];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
	if ([notification object] == tvProjects) {
		// Save the last task for the old project
		if (_selProject != nil) {
			NSNumber *index = [NSNumber numberWithInt:[tvTasks selectedRow]];
			[_projects_lastTask setObject:index forKey:[_selProject name]];
		}
	
		// Update the new selection
		if ([tvProjects selectedRow] == -1) {
			_selProject = nil;
		} else {
			_selProject = [document objectInProjectsAtIndex:[tvProjects selectedRow]];
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
	}
	
	if ([notification object] == tvTasks) {
		if ([tvTasks selectedRow] == -1) {
			_selTask = nil;
		} else {
			// assert _selProject != nil
			_selTask = [[_selProject tasks] objectAtIndex: [tvTasks selectedRow]];
		}
		[tvWorkPeriods reloadData];
	}

}

- (void)tableView:(NSTableView *)tableView 
	setObjectValue:(id)obj 
	forTableColumn:(NSTableColumn *)tableColumn 
	row:(int)rowIndex
{
	if (tableView == tvProjects) {
		if ([[tableColumn identifier] isEqualToString:TABLE_COLUMN_PROJECT_NAME])
			[_selProject setName: obj];
	}
	if (tableView == tvTasks) {
		if ([[tableColumn identifier] isEqualToString:TABLE_COLUMN_TASK_NAME])
			[_selTask setName: obj];
	}
}

- (IBAction)clickedDelete:(id)sender
{
	if ([mainWindow firstResponder] == tvWorkPeriods) {
		// assert _selTask != nil
		// assert _selProject != nil
		TWorkPeriod *_selWorkPeriod = [documentController workPeriodAtIndex:[tvWorkPeriods selectedRow]];
		// assert _selWorkPeriod != nil
		if (_selWorkPeriod == _curWorkPeriod) {
			[self stopTimer];
		}
    [[_selTask workPeriods] removeObject:_selWorkPeriod];
		[tvWorkPeriods deselectAll: self];
		[tvWorkPeriods reloadData];
		[tvTasks reloadData];
		[tvProjects reloadData];
	}
	if ([mainWindow firstResponder] == tvTasks) {
		// assert _selTask != nil
		// assert _selProject != nil
		if (_selTask == _curTask) {
			[self stopTimer];
		}
		TTask *delTask = _selTask;
		[tvTasks deselectAll: self];
		[[_selProject tasks] removeObject: delTask];
		[tvTasks reloadData];
		[tvProjects reloadData];
	}
	if ([mainWindow firstResponder] == tvProjects) {
		// assert _selProject != nil
		if (_selProject == _curProject) {
			[self stopTimer];
		}
		TProject *delProject = _selProject;
		[tvProjects deselectAll: self];
		[document removeProject:delProject];
		[tvProjects reloadData];
	}
}

- (IBAction)clickedCountIdleTimeYes:(id)sender
{
  [timer resume];
	[NSApp stopModal];
}

- (BOOL) validateUserInterfaceItem:(id)anItem
{
	if ([anItem action] == @selector(clickedStartStopTimer:)) {
		return YES;
	} else
	if ([anItem action] == @selector(clickedAddProject:)) {
		return YES;
	} else
	if ([anItem action] == @selector(clickedAddTask:)) {
		if (_selProject != nil) return YES;
		return NO;
	}
	return YES;
}

- (void)updateStartStopState
{
  if ( ![timer isRunning] ) {
		// Timer is stopped: show the Start button
		if (startstopToolbarItem != nil) {
			[startstopToolbarItem setLabel:NSLocalizedString(@"Start", "Short version of the 'start the timer' action")];
			[startstopToolbarItem setPaletteLabel:NSLocalizedString(@"Start", nil)];
			[startstopToolbarItem setToolTip:NSLocalizedString(@"Start Timer", "Phrase version of the 'start the timer' action")];
			[startstopToolbarItem setImage:playToolImage];
		}
		
		// assert statusItem != nil
		[statusItem setImage:playItemImage];
		[statusItem setAlternateImage:playItemHighlightImage];
		
		// assert startMenuItem != nil
		[startMenuItem setTitle:NSLocalizedString(@"Start Timer", nil)];
	} else {
		if (startstopToolbarItem != nil) {
			[startstopToolbarItem setLabel:NSLocalizedString(@"Stop", "Short version of the 'stop the timer' action")];
			[startstopToolbarItem setPaletteLabel:NSLocalizedString(@"Stop", nil)];
			[startstopToolbarItem setToolTip:NSLocalizedString(@"Stop Timer", "Phrase version of the 'stop the timer' action")];
			[startstopToolbarItem setImage:stopToolImage];
		}
		
		// assert statusItem != nil
		[statusItem setImage:stopItemImage];
		[statusItem setAlternateImage:stopItemHighlightImage];
		
		// assert startMenuItem != nil
		[startMenuItem setTitle:NSLocalizedString(@"Stop Timer", nil)];
	}
	
}

- (IBAction)clickedCountIdleTimeNo:(id)sender
{
  [NSApp stopModal];
  [timer cancel];
  [self stopTimer];
}


#pragma mark setters

- (void)setMainWindow:(NSWindow *)w
{
  [mainWindow release];
  mainWindow = [w retain];
}

- (NSWindow *)mainWindow
{
  return mainWindow;
}

- (void)setProjectsTableView:(NSTableView *)tv
{
	[tvProjects release];
	tvProjects = [tv retain];
}

- (void)setTasksTableView:(NSTableView *)tv
{
	[tvTasks release];
	tvTasks = [tv retain];
}

- (void)setWorkPeriodsTableView:(NSTableView *)tv
{
  [tvWorkPeriods release];
  tvWorkPeriods = [tv retain];
}

- (TTDocumentV1 *)document
{
	return document;
}

- (void)setDocument:(TTDocumentV1 *)aDocument
{
	[document release];
	document = [aDocument retain];
	[tvProjects reloadData];
	[tvTasks reloadData];
	[tvWorkPeriods reloadData];
}

- (id)documentController
{
  return documentController;
}

- (void)setDocumentController:(id)aDocumentController
{
  if (documentController != aDocumentController)
  {
    [documentController release];
    documentController = [aDocumentController retain];    
  }
}

- (void)setTimeProvider:(TTTimeProvider *)tp
{
  if (timeProvider != tp)
  {
    [timeProvider release];
    timeProvider = [tp retain];
  }
}

- (void)setTimer:(TTTimer *)aTimer
{
  if (timer != aTimer)
  {
    [timer release];
    timer = [aTimer retain];
  }
}

- (TTTimer *)timer
{
  return timer;
}

- (TProject *)selectedProject
{
	return _selProject;
}

- (void)setSelectedProject:(TProject *)aProject
{
	[_selProject release];
	_selProject = [aProject retain];
}

- (void)setSelectedTask:(TTask *)aTask
{
  [_selTask release];
  _selTask = [aTask retain];
}

- (void)setFilterStartTime:(NSDate *)startTime endTime:(NSDate *)endTime
{
  if (filterStartTime != startTime)
  {
    [filterStartTime release];
    filterStartTime = [startTime retain];    
  }
  if (filterEndTime != endTime)
  {
    [filterEndTime release];
    filterEndTime = [endTime retain];
  }
	[tvProjects reloadData];
	[tvTasks reloadData];
	[tvWorkPeriods reloadData];
}

- (void)clearFilter
{
	[filterStartTime release];
	[filterEndTime release];
	filterStartTime = nil;
	filterEndTime = nil;
	[tvProjects reloadData];
	[tvTasks reloadData];
	[tvWorkPeriods reloadData];
}

- (TTask*)activeTask
{
	return _curTask;
}

- (TTask*)selectedTask
{
	return _selTask;
}

#pragma mark TTTimer delegate methods

- (void)timerHasChanged:(NSDate *)date
{
  [_curWorkPeriod setEndTime:date];
  
  // Redraw just the TotalTime columns so that editing doesn't get cancelled if the user
  // is currently editing a different cell.
  [tvProjects setNeedsDisplayInRect:[tvProjects rectOfColumn:[tvProjects columnWithIdentifier:TABLE_COLUMN_TOTAL_TIME]]];
  [tvTasks setNeedsDisplayInRect:[tvTasks rectOfColumn:[tvTasks columnWithIdentifier:TABLE_COLUMN_TOTAL_TIME]]];
  
  [tvWorkPeriods reloadData];
  
  if (timeSinceSave > 5 * 60) {
    [self saveData];
  } else {
    timeSinceSave++;
  }
}

- (void)timerHasBecomeIdle
{
  [NSApp activateIgnoringOtherApps:YES];
  [NSApp runModalForWindow:panelIdleNotification];
  [panelIdleNotification orderOut:self];
}

#pragma mark NSTableView delegate methods

- (BOOL)tableView:(NSTableView *)aTableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes 
	toPasteboard:(NSPasteboard *)pboard
{
	if (aTableView == tvProjects)
	{
		NSArray *typesArray = [NSArray arrayWithObjects:PBOARD_TYPE_PROJECT_ROWS, nil];
		[pboard declareTypes:typesArray owner:self];
		
		NSData *rowIndexesArchive = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
	    [pboard setData:rowIndexesArchive forType:PBOARD_TYPE_PROJECT_ROWS];
	
		return YES;
	}
	if (aTableView == tvTasks)
	{
		NSArray *typesArray = [NSArray arrayWithObjects:PBOARD_TYPE_TASK_ROWS, nil];
		[pboard declareTypes:typesArray owner:self];

		NSData *rowIndexesArchive = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
		[pboard setData:rowIndexesArchive forType:PBOARD_TYPE_TASK_ROWS];
		
		return YES;
	}
	return NO;
}

- (NSDragOperation)tableView:(NSTableView *)aTableView validateDrop:(id < NSDraggingInfo >)info 
	proposedRow:(int)row proposedDropOperation:(NSTableViewDropOperation)operation
{
	if (aTableView == tvProjects && [info draggingSource] == tvProjects)
	{
		[aTableView setDropRow:row dropOperation:NSTableViewDropAbove];
		return NSDragOperationMove;
	}
	if (aTableView == tvTasks && [info draggingSource] == tvTasks)
	{
		[aTableView setDropRow:row dropOperation:NSTableViewDropAbove];
		return NSDragOperationMove;
	}
	return NSDragOperationNone;
}

- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id < NSDraggingInfo >)info 
	row:(int)row dropOperation:(NSTableViewDropOperation)operation
{
	if (aTableView == tvProjects && [info draggingSource] == tvProjects)
	{
		NSData *rowsData = [[info draggingPasteboard] dataForType:PBOARD_TYPE_PROJECT_ROWS];
		NSIndexSet *indexSet = [NSKeyedUnarchiver unarchiveObjectWithData:rowsData];
		
		int sourceRow = [indexSet firstIndex];
		[document moveProject:[document objectInProjectsAtIndex:sourceRow] toIndex:row];
		
		[tvProjects reloadData];
		return YES;
	}
	if (aTableView == tvTasks && [info draggingSource] == tvTasks)
	{
		NSData *rowsData = [[info draggingPasteboard] dataForType:PBOARD_TYPE_TASK_ROWS];
		NSIndexSet *indexSet = [NSKeyedUnarchiver unarchiveObjectWithData:rowsData];
		
		int sourceRow = [indexSet firstIndex];
		[_selProject moveTask:[_selProject objectInTasksAtIndex:sourceRow] toIndex:row];
		
		[tvTasks reloadData];
		return YES;
	}
	return NO;
}


- (IBAction)filterToAll:(id)sender
{
	[documentController clearFilter];
}

- (IBAction)filterToToday:(id)sender
{
	[documentController setFilterStartTime:[timeProvider todayStartTime]
	  endTime:[timeProvider todayEndTime]];
}

- (IBAction)filterToYesterday:(id)sender
{
	[documentController setFilterStartTime:[timeProvider yesterdayStartTime]
	  endTime:[timeProvider yesterdayEndTime]];
}

- (IBAction)filterToThisWeek:(id)sender
{
	[documentController setFilterStartTime:[timeProvider thisWeekStartTime]
	  endTime:[timeProvider thisWeekEndTime]];
}

- (IBAction)filterToLastWeek:(id)sender
{
	[documentController setFilterStartTime:[timeProvider lastWeekStartTime]
	  endTime:[timeProvider lastWeekEndTime]];
}

- (IBAction)filterToWeekBeforeLast:(id)sender
{
  [documentController setFilterStartTime:[timeProvider weekBeforeLastStartTime]
	  endTime:[timeProvider weekBeforeLastEndTime]];
}

- (IBAction)filterToThisMonth:(id)sender
{
	[documentController setFilterStartTime:[timeProvider thisMonthStartTime]
	  endTime:[timeProvider thisMonthEndTime]];
}

- (IBAction)filterToLastMonth:(id)sender
{
	[documentController setFilterStartTime:[timeProvider lastMonthStartTime]
	  endTime:[timeProvider lastMonthEndTime]];
}


@end
