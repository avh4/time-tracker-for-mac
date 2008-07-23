require File.dirname(__FILE__) + '/spec_helper'

require "Application.bundle"
OSX::ns_import :TTDataSource

describe OSX::TTDataSource do
  
  before do
    @document = OSX::TTDocument.alloc.init
    @project1 = OSX::TProject.alloc.init
    @task1_1 = mock("Task 1.1")
    @task1_2 = mock("Task 1.2")
    @project1.setTasks( [@task1_1, @task1_2] )
    @document.setProjects( [@project1] )
    
    @colName = mock("NSTableColumn - ProjectName")
    @colName.stub!(:identifier).and_return("ProjectName")
    @colTotalTime = mock("NSTableColumn - TotalTime")
    @colTotalTime.stub!(:identifier).and_return("TotalTime")
  end
  
  it "should return the tree data for the root node (the document)" do
    # Set up objects
    mockOutline = mock("NSOutlineView")
    ds = OSX::TTDataSource.alloc.init
    ds.setDocument(@document)
    
    # Perform the test and assertations
    ds.outlineView_numberOfChildrenOfItem(mockOutline, nil).should == 1
    ds.outlineView_child_ofItem(mockOutline, 0, nil).should == @project1
    ds.outlineView_isItemExpandable(mockOutline, nil).should be_true    
  end

  it "should return the tree data for a project" do
    # Set up objects
    mockOutline = mock("NSOutlineView")
    ds = OSX::TTDataSource.alloc.init
    
    # Perform the test and assertations
    ds.outlineView_numberOfChildrenOfItem(mockOutline, @project1).should == 2
    ds.outlineView_child_ofItem(mockOutline, 0, @project1).should == @task1_1
    ds.outlineView_isItemExpandable(mockOutline, @project1).should be_true    
  end
  
  it "should return the tree data for a task" do
    # Set up objects
    mockOutline = mock("NSOutlineView")
    ds = OSX::TTDataSource.alloc.init
    
    # Perform the test and assertations
    ds.outlineView_numberOfChildrenOfItem(mockOutline, @task1_1).should == 0
    ds.outlineView_isItemExpandable(mockOutline, @task1_1).should be_false
  end
  
  it "should return the column data for a project" do
    # Set up constants
    totalTime = 79
    
    # Set up objects
    mockOutline = mock("NSOutlineView")
    ds = OSX::TTDataSource.alloc.init
    
    mockProject = MockProject.new
    mockProject.should_receive(:name).and_return("Project 1")
    mockProject.should_receive(:totalTime).and_return(totalTime)
    
    # Perform the test and assertations
    ds.outlineView_objectValueForTableColumn_byItem(mockOutline, @colName, mockProject)\
      .should == "Project 1"
    ds.outlineView_objectValueForTableColumn_byItem(mockOutline, @colTotalTime, mockProject)\
      .should == "00:01:19"
  end
  
  it "should return the column data for a task" do
    # Set up constants
    name = "Task 1.1"
    totalTime = 81
    totalTime_STRING = "00:01:21"
    
    # Set up objects
    mockOutline = mock("NSOutlineView")
    ds = OSX::TTDataSource.alloc.init
    
    mockTask = MockTask_.new
    mockTask.should_receive(:name).and_return(name)
    mockTask.should_receive(:totalTime).and_return(totalTime)
    
    # Perform the test and assertations
    ds.outlineView_objectValueForTableColumn_byItem(mockOutline, @colName, mockTask)\
      .should == name
    ds.outlineView_objectValueForTableColumn_byItem(mockOutline, @colTotalTime, mockTask)\
      .should == totalTime_STRING
  end
  
end