require File.dirname(__FILE__) + '/spec_helper'

describe OSX::MainController do
  
  it "should create a blank document when initialized" do
    mc = OSX::MainController.alloc.init
    mc.document.should_not be_nil
    mc.document.projects.should_not be_nil
    mc.document.projects.size.should equal(0)
  end
  
  it "should update the selected project when the table selection changes" do
    mc = OSX::MainController.alloc.init
    mockTableView = MockNSTableView.new
    mockNotification = mock("NSNotification")
    mockDocument = MockDocument.new
    mockProject = MockProject.new
    mockNotification.stub!(:object).and_return(mockTableView)
    mockTableView.stub!(:selectedRow).and_return(1)
    mockDocument.stub!(:objectInProjectsAtIndex).with(1).and_return(mockProject)
    mockProject.stub!(:tasks).and_return([])
    
    mc.setDocument(mockDocument)
    mc.setProjectsTableView(mockTableView)
    
    mc.tableViewSelectionDidChange(mockNotification)

    mc.selectedProject.should equal(mockProject)
  end

  it "should enable the start button when a task is selected" do
    mc = OSX::MainController.alloc.init
    mockTask = MockUserInterfaceItem.new
    #mc.setSelectedTask(mockTask)
    mockInterfaceItem = mock("Star/Stop Interface Item")
    pending "Don't know how to make the mock return a SEL"
    #mockInterfaceItem.stub!(:action).and_return(:clickedStartStopTimer_)
    
    mc.validateUserInterfaceItem(mockInterfaceItem).should == true
  end
  
  it "should enable the stop button when the timer is running" do
    mc = OSX::MainController.alloc.init
    mc.startTimer
    #mc.setSelectedTask(nil)
    #mc.setSelectedProject(nil)
    mockInterfaceItem = mock("Star/Stop Interface Item")
    pending "Don't know how to make the mock return a SEL"
    #mockInterfaceItem.stub!(:action).and_return(:clickedStartStopTimer_)
    
    mc.validateUserInterfaceItem(mockInterfaceItem).should == true
  end
  
  it "should enable the start button when no task is selected" do
    mc = OSX::MainController.alloc.init
    #mc.setSelectedTask(nil)
    #mc.setSelectedProject(nil)
    mockInterfaceItem = mock("Star/Stop Interface Item")
    pending "Don't know how to make the mock return a SEL"
    #mockInterfaceItem.stub!(:action).and_return(:clickedStartStopTimer_)
    
    mc.validateUserInterfaceItem(mockInterfaceItem).should == true
  end
  
  it "should create a document controller" do
    @mc = OSX::MainController.alloc.init
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
      @mockDocCont = mock("Document controller")
      @mockTimeProvider = mock("TTTimeProvider")
      @mc.documentController = @mockDocCont
      @mc.timeProvider = @mockTimeProvider
      
      @mockDocCont.stub!(:setFilterStartTime_endTime)
      @mockDocCont.stub!(:clearFilter)
      @mockStartTime = mock("start time")
      @mockEndTime = mock("end time")
    end
    
    it "should clear the filter" do
      @mockDocCont.should_receive(:clearFilter)
      @mc.filterToAll(nil)
    end
    
  end
  
end