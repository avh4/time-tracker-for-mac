require File.dirname(__FILE__) + '/spec_helper'

describe OSX::MainController do
  
  before(:each) do
    @loader = mock("Document Loader")
    @new_doc = OSX::TTDocumentV1.alloc.init
    @loader.stub!(:loadDocument).and_return(@new_doc)
    @mc = OSX::MainController.alloc.initWithDocumentLoader(@loader)
  end
  
  it "should create a blank document when initialized" do
    @mc.document.should_not be_nil
    @mc.document.projects.should_not be_nil
    @mc.document.projects.size.should equal(0)
  end
  
  it "should update the selected project when the table selection changes" do
    mockTableView = MockNSTableView.new
    mockNotification = mock("NSNotification")
    mockDocument = MockDocument.new
    mockProject = MockProject.new
    mockNotification.stub!(:object).and_return(mockTableView)
    mockTableView.stub!(:selectedRow).and_return(1)
    mockDocument.stub!(:objectInProjectsAtIndex).with(1).and_return(mockProject)
    mockProject.stub!(:tasks).and_return([])
    
    @mc.setDocument(mockDocument)
    @mc.setProjectsTableView(mockTableView)
    
    @mc.tableViewSelectionDidChange(mockNotification)
    
    @mc.selectedProject.should equal(mockProject)
  end
  
  it "should enable the start button when a task is selected" do
    mockTask = MockUserInterfaceItem.new
    #mc.setSelectedTask(mockTask)
    mockInterfaceItem = mock("Star/Stop Interface Item")
    pending "Don't know how to make the mock return a SEL"
    #mockInterfaceItem.stub!(:action).and_return(:clickedStartStopTimer_)
    
    @mc.validateUserInterfaceItem(mockInterfaceItem).should == true
  end
  
  it "should enable the stop button when the timer is running" do
    @mc.startTimer
    #@mc.setSelectedTask(nil)
    #@mc.setSelectedProject(nil)
    mockInterfaceItem = mock("Star/Stop Interface Item")
    pending "Don't know how to make the mock return a SEL"
    #mockInterfaceItem.stub!(:action).and_return(:clickedStartStopTimer_)
    
    @mc.validateUserInterfaceItem(mockInterfaceItem).should == true
  end
  
  it "should enable the start button when no task is selected" do
    #@mc.setSelectedTask(nil)
    #@mc.setSelectedProject(nil)
    mockInterfaceItem = mock("Star/Stop Interface Item")
    pending "Don't know how to make the mock return a SEL"
    #mockInterfaceItem.stub!(:action).and_return(:clickedStartStopTimer_)
    
    @mc.validateUserInterfaceItem(mockInterfaceItem).should == true
  end
  
  it "should create a document controller" do
    @mc.documentController.should_not be_nil
  end
  
  describe "view controller functionality" do 
    before(:each) do
      @mc = OSX::MainController.alloc.init
      @mockDocContr = MockDocumentController.new
      @mockTVWorkPeriods = MockNSTableView.new
      @mockMainWindow = MockNSWindow.new
      @mc.documentController = @mockDocContr
      @mc.workPeriodsTableView = @mockTVWorkPeriods
      @mc.mainWindow = @mockMainWindow
      
      @mockTVWorkPeriods.stub!(:reloadData)
      @mockTVWorkPeriods.stub!(:deselectAll)
    end
    
    it "should ask the document controller for the work period when double-clicking" do
      clickIndex = 3
      @mockTVWorkPeriods.stub!(:selectedRow).and_return(clickIndex)
      @mockDocContr.should_receive(:workPeriodAtIndex).with(clickIndex)
      @mc.doubleClickWorkPeriod(nil)
    end

    it "should ask the document controller for the work period when closing the change dialog" do
      clickIndex = 3
      @mockTVWorkPeriods.stub!(:selectedRow).and_return(clickIndex)
      @mockDocContr.should_receive(:workPeriodAtIndex).with(clickIndex)
      @mc.clickedChangeWorkPeriod(nil)
    end

    it "should ask the document controller for the work period when deleting a work period" do
      clickIndex = 3
      @mockMainWindow.stub!(:firstResponder).and_return(@mockTVWorkPeriods)
      @mockTVWorkPeriods.stub!(:selectedRow).and_return(clickIndex)
      @mockDocContr.should_receive(:workPeriodAtIndex).with(clickIndex)
      @mc.clickedDelete(nil)
    end
  end
  
  describe "document controller functionality" do
    # this functionality is currently part of MainController, but it would
    # make sense to move this into a new class that manages the selection
    # state, similar to NSArrayController
    before(:each) do
      @dc = OSX::MainController.alloc.init
      @mockDoc = MockDocument.new
      @mockSelTask = MockTask.new
      @filterStart = mock("filter start time")
      @filterEnd = mock("filter end time")
      @filterStart.stub!(:copy).and_return(@filterStart)
      @filterEnd.stub!(:copy).and_return(@filterEnd)
      @dc.document = @mockDoc
      @dc.selectedTask = @mockSelTask
      
      @mockSelTask.stub!(:workPeriods)
      @mockSelTask.stub!(:workPeriodsInRangeFrom_to)
    end
    
    it "should return the work period at a given index" do
      index = 8
      mockArray = MockNSArray.new
      @mockSelTask.should_receive(:workPeriods).and_return(mockArray)
      mockArray.should_receive(:objectAtIndex).with(index)
      @dc.workPeriodAtIndex(index)
    end
    
    it "should return the work period at a given index with filters" do
      index = 8
      @dc.setFilterStartTime_endTime(@filterStart, @filterEnd)
      mockArray = MockNSArray.new
      @mockSelTask.should_receive(:workPeriodsInRangeFrom_to).and_return(mockArray)
      mockArray.should_receive(:objectAtIndex).with(index)
      @dc.workPeriodAtIndex(index)
    end
  end
  
  describe "filter actions" do
    
    before(:each) do
      @mc = OSX::MainController.alloc.init
      @mockDocCont = MockDocumentController.new
      @mockTimeProvider = mock("TTTimeProvider")
      @mc.documentController = @mockDocCont
      @mc.timeProvider = @mockTimeProvider
      
      @mockDocCont.stub!(:setFilterStartTime_endTime)
      @mockDocCont.stub!(:clearFilter)
      @mockStart = mock("start time")
      @mockEnd = mock("end time")
    end
    
    it "should clear the filter" do
      @mockDocCont.should_receive(:clearFilter)
      @mc.filterToAll(nil)
    end
    
    it "should filter to today" do
      @mockTimeProvider.stub!(:todayStartTime).and_return(@mockStart)
      @mockTimeProvider.stub!(:todayEndTime).and_return(@mockEnd)
      @mockDocCont.should_receive(:setFilterStartTime_endTime).with(@mockStart, @mockEnd)
      @mc.filterToToday(nil)
    end
    
    it "should filter to yesterday" do
      @mockTimeProvider.stub!(:yesterdayStartTime).and_return(@mockStart)
      @mockTimeProvider.stub!(:yesterdayEndTime).and_return(@mockEnd)
      @mockDocCont.should_receive(:setFilterStartTime_endTime).with(@mockStart, @mockEnd)
      @mc.filterToYesterday(nil)
    end
    
    it "should filter to this week" do
      @mockTimeProvider.stub!(:thisWeekStartTime).and_return(@mockStart)
      @mockTimeProvider.stub!(:thisWeekEndTime).and_return(@mockEnd)
      @mockDocCont.should_receive(:setFilterStartTime_endTime).with(@mockStart, @mockEnd)
      @mc.filterToThisWeek(nil)
    end

    it "should filter to last week" do
      @mockTimeProvider.stub!(:lastWeekStartTime).and_return(@mockStart)
      @mockTimeProvider.stub!(:lastWeekEndTime).and_return(@mockEnd)
      @mockDocCont.should_receive(:setFilterStartTime_endTime).with(@mockStart, @mockEnd)
      @mc.filterToLastWeek(nil)
    end

    it "should filter to 'week before last'" do
      @mockTimeProvider.stub!(:weekBeforeLastStartTime).and_return(@mockStart)
      @mockTimeProvider.stub!(:weekBeforeLastEndTime).and_return(@mockEnd)
      @mockDocCont.should_receive(:setFilterStartTime_endTime).with(@mockStart, @mockEnd)
      @mc.filterToWeekBeforeLast(nil)
    end

    it "should filter to this month" do
      @mockTimeProvider.stub!(:thisMonthStartTime).and_return(@mockStart)
      @mockTimeProvider.stub!(:thisMonthEndTime).and_return(@mockEnd)
      @mockDocCont.should_receive(:setFilterStartTime_endTime).with(@mockStart, @mockEnd)
      @mc.filterToThisMonth(nil)
    end

    it "should filter to last month" do
      @mockTimeProvider.stub!(:lastMonthStartTime).and_return(@mockStart)
      @mockTimeProvider.stub!(:lastMonthEndTime).and_return(@mockEnd)
      @mockDocCont.should_receive(:setFilterStartTime_endTime).with(@mockStart, @mockEnd)
      @mc.filterToLastMonth(nil)
    end
    
  end
  
end