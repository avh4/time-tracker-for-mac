require File.dirname(__FILE__) + '/spec_helper'

require "Application.bundle"
OSX::ns_import :TTDataSource

describe OSX::TTDataSource do
  
  before do
    DOCUMENT = OSX::TTDocument.alloc.init
    PROJECT_1 = OSX::TProject.alloc.init
    TASK_1_1 = mock("Task 1.1")
    TASK_1_2 = mock("Task 1.2")
    PROJECT_1.setTasks( [TASK_1_1, TASK_1_2] )
    DOCUMENT.setProjects( [PROJECT_1] )
    
    COL_NAME = mock("NSTableColumn - ProjectName")
    COL_NAME.stub!(:identifier).and_return("ProjectName")
    COL_TOTAL_TIME = mock("NSTableColumn - TotalTime")
    COL_TOTAL_TIME.stub!(:identifier).and_return("TotalTime")
  end
  
  it "should return the tree data for the root node (the document)" do
    # Set up objects
    mockOutline = mock("NSOutlineView")
    ds = OSX::TTDataSource.alloc.init
    ds.setDocument(DOCUMENT)
    
    # Perform the test and assertations
    ds.outlineView_numberOfChildrenOfItem(mockOutline, nil).should == 1
    ds.outlineView_child_ofItem(mockOutline, 0, nil).should == PROJECT_1
    ds.outlineView_isItemExpandable(mockOutline, nil).should be_true    
  end

  it "should return the tree data for a project" do
    # Set up objects
    mockOutline = mock("NSOutlineView")
    ds = OSX::TTDataSource.alloc.init
    
    # Perform the test and assertations
    ds.outlineView_numberOfChildrenOfItem(mockOutline, PROJECT_1).should == 2
    ds.outlineView_child_ofItem(mockOutline, 0, PROJECT_1).should == TASK_1_1
    ds.outlineView_isItemExpandable(mockOutline, PROJECT_1).should be_true    
  end
  
  it "should return the tree data for a task" do
    # Set up objects
    mockOutline = mock("NSOutlineView")
    ds = OSX::TTDataSource.alloc.init
    
    # Perform the test and assertations
    ds.outlineView_numberOfChildrenOfItem(mockOutline, TASK_1_1).should == 0
    ds.outlineView_isItemExpandable(mockOutline, TASK_1_1).should be_false
  end
  
  # Here we are creating a mock object that Obj-C thinks is a subclass
  # of TProject, but which ignores the Obj-C implementation of TProject.
  # This trick is used to allow rmock to intercept a method that would normally
  # be handled by the obj-c class without rmock even knowing about it:
  #
  #   def the_method_to_hide
  #     return super.super.the_method_to_hide
  #   end
  #
  class MockProject < OSX::TProject
    def name
      return super.super.name
    end
    def totalTime
      return super.super.totalTime
    end
  end
  
  # "MockTask" is already defined in t_project_spec.rb
  class MockTask_ < OSX::TTask
    def name
      return super.super.name
    end
    def totalTime
      return super.super.totalTime
    end
  end
  
  it "should return the column data for a project" do
    # Set up constants
    TOTAL_TIME = 79
    
    # Set up objects
    mockOutline = mock("NSOutlineView")
    ds = OSX::TTDataSource.alloc.init
    
    mockProject = MockProject.new
    mockProject.should_receive(:name).and_return("Project 1")
    mockProject.should_receive(:totalTime).and_return(TOTAL_TIME)
    
    # Perform the test and assertations
    ds.outlineView_objectValueForTableColumn_byItem(mockOutline, COL_NAME, mockProject)\
      .should == "Project 1"
    ds.outlineView_objectValueForTableColumn_byItem(mockOutline, COL_TOTAL_TIME, mockProject)\
      .should == "00:01:19"
  end
  
  it "should return the column data for a task" do
    # Set up constants
    NAME = "Task 1.1"
    TOTAL_TIME = 81
    TOTAL_TIME_STRING = "00:01:21"
    
    # Set up objects
    mockOutline = mock("NSOutlineView")
    ds = OSX::TTDataSource.alloc.init
    
    mockTask = MockTask_.new
    mockTask.should_receive(:name).and_return(NAME)
    mockTask.should_receive(:totalTime).and_return(TOTAL_TIME)
    
    # Perform the test and assertations
    ds.outlineView_objectValueForTableColumn_byItem(mockOutline, COL_NAME, mockTask)\
      .should == NAME
    ds.outlineView_objectValueForTableColumn_byItem(mockOutline, COL_TOTAL_TIME, mockTask)\
      .should == TOTAL_TIME_STRING
  end
  
end