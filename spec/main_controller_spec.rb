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
  
end