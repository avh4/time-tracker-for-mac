require File.dirname(__FILE__) + '/spec_helper'

describe OSX::MainController do
  
  before(:each) do
    @loader = mock("Document Loader")
    @doc = OSX::TTDocumentV1.alloc.init
    @loader.stub!(:loadDocument).and_return(@doc)
    @mc = OSX::MainController.alloc.initWithDocumentLoader(@loader)
    @doc.should == @mc.document
  end
  
  describe "with demo data" do
    before(:each) do
      @doc.createProject("Project 1")
      @doc.projects[0].createTask("Task 1.1")
      @doc.createProject("Project 2")
    end
    describe "with a project/task selected" do
      before(:each) do
        @mc.selectedProject = @doc.projects[0]
        @mc.selectedTask = @doc.projects[0].tasks[0]
      end
      it "should enable the start buttom" do
        pending
      end
      describe "when the timer is started" do
        before(:each) do
          @mc.startTimer
        end
        it "should set the active project" do
          @mc.activeProject.should == @doc.projects[0]
        end
        it "should set the active task" do
          @mc.activeTask.should == @doc.projects[0].tasks[0]
        end
        it "should set the active work period" do
          @mc.activeWorkPeriod.should == @doc.projects[0].tasks[0].workPeriods[0]
        end
        it "should enable the stop button" do
          pending
        end
      end
      describe "when the project table selection changes" do
        before(:each) do
          mockTableView = MockNSTableView.new
          mockTableView.stub!(:selectedRow).and_return(1)
          @mc.setProjectsTableView(mockTableView)
          
          mockNotification = mock("NSNotification")
          mockNotification.stub!(:object).and_return(mockTableView)
          
          @mc.tableViewSelectionDidChange(mockNotification)
        end
        it "should update the selected project" do
          @mc.selectedProject.should equal(@doc.projects[1])
        end
      end
    end
    describe "with no project/task selected" do
      before(:each) do
        @mc.selectedProject = nil
        @mc.selectedTask = nil
      end
      it "should enable the start button" do
        pending
      end
    end
  end
  
  # describe "document controller functionality" do
  #   # this functionality is currently part of MainController, but it would
  #   # make sense to move this into a new class that manages the selection
  #   # state, similar to NSArrayController
  #   before(:each) do
  #     @dc = OSX::MainController.alloc.init
  #     @mockDoc = MockDocument.new
  #     @mockSelTask = MockTask.new
  #     @filterStart = mock("filter start time")
  #     @filterEnd = mock("filter end time")
  #     @filterStart.stub!(:copy).and_return(@filterStart)
  #     @filterEnd.stub!(:copy).and_return(@filterEnd)
  #     @dc.document = @mockDoc
  #     @dc.selectedTask = @mockSelTask
  #     
  #     @mockSelTask.stub!(:workPeriods)
  #     @mockSelTask.stub!(:workPeriodsInRangeFrom_to)
  #   end
  #   
  #   it "should return the work period at a given index" do
  #     index = 8
  #     mockArray = MockNSArray.new
  #     @mockSelTask.should_receive(:workPeriods).and_return(mockArray)
  #     mockArray.should_receive(:objectAtIndex).with(index)
  #     @dc.workPeriodAtIndex(index)
  #   end
  #   
  #   it "should return the work period at a given index with filters" do
  #     index = 8
  #     @dc.setFilterStartTime_endTime(@filterStart, @filterEnd)
  #     mockArray = MockNSArray.new
  #     @mockSelTask.should_receive(:workPeriodsInRangeFrom_to).and_return(mockArray)
  #     mockArray.should_receive(:objectAtIndex).with(index)
  #     @dc.workPeriodAtIndex(index)
  #   end
  # end
  # 
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