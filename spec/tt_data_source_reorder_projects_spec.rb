require "Application.bundle"

describe OSX::MainController do
  
  it "should configure the projects table to accept drops" do
    mc = OSX::MainController.alloc.init
    mockTableViewProjects = mock("NSTableView Projects")
    mc.setProjectsTableView(mockTableViewProjects)

    mockTableViewProjects.stub!(:reloadData)
    
    mockTableViewProjects.should_receive(:registerForDraggedTypes)

    mc.awakeFromNib
  end
  
  it "should allow table rows to be dragged" do
    mc = OSX::MainController.alloc.init
    mockTableViewProjects = mock("NSTableView Projects")
    mc.setProjectsTableView(mockTableViewProjects)
    dragRows = OSX::NSMutableIndexSet.alloc.init
    dragRows.addIndex(1)
    pasteboard = OSX::NSPasteboard.pasteboardWithName("rspec pasteboard")
    
    mc.tableView_writeRowsWithIndexes_toPasteboard(
        mockTableViewProjects, dragRows, pasteboard
        ).should be_true

    # The pastboard must have the TIME_TRACKER_PROJECT_ROWS type
    types = pasteboard.types
    types.index("TIME_TRACKER_PROJECT_ROWS").should_not be_nil
    
    # Check the contents of the TIME_TRACKER_PROJECT_ROWS data
    rowData = pasteboard.dataForType("TIME_TRACKER_PROJECT_ROWS")
    rowDataUnarchived = OSX::NSKeyedUnarchiver.unarchiveObjectWithData(rowData)
    rowDataUnarchived.isKindOfClass(OSX::NSIndexSet).should be_true
    rowDataUnarchived.count.should equal(1)
    rowDataUnarchived.firstIndex.should equal(1)
    
  end
  
  it "should reject drags from other sources" do
    mc = OSX::MainController.alloc.init
    mockTableViewProjects = mock("NSTableView Projects")
    mc.setProjectsTableView(mockTableViewProjects)
    mockDraggingInfo = mock("NSDraggingInfo")
    dropRow = 0
    dropOperation = OSX::NSTableViewDropAbove
    mockOtherDragSource = mock("Other drag source")
    
    mockDraggingInfo.stub!(:draggingSource).and_return(mockOtherDragSource)
    
    mc.tableView_validateDrop_proposedRow_proposedDropOperation(
        mockTableViewProjects, mockDraggingInfo, dropRow, dropOperation
        ).should equal(OSX::NSDragOperationNone)
    
  end
  
  it "should validate drops when moving rows within the table" do
    mc = OSX::MainController.alloc.init
    mockTableViewProjects = mock("NSTableView Projects")
    mc.setProjectsTableView(mockTableViewProjects)
    mockDraggingInfo = mock("NSDraggingInfo")
    dropRow = 0
    dropOperation = OSX::NSTableViewDropAbove
    
    mockDraggingInfo.stub!(:draggingSource).and_return(mockTableViewProjects)
    
    mockTableViewProjects.should_receive(:setDropRow_dropOperation)
    
    mc.tableView_validateDrop_proposedRow_proposedDropOperation(
        mockTableViewProjects, mockDraggingInfo, dropRow, dropOperation
        ).should equal(OSX::NSDragOperationMove)
    
  end
  
  class MockDocument < OSX::NSObject
    objc_method :objectInProjectsAtIndex, "@@:i"
    objc_method :moveProject_toIndex, "v@:@i"
  end
  
  
  it "should accept drops when moving rows within the table" do
    mockTableViewProjects = mock("NSTableView Projects")
    mockTableViewProjects.stub!(:reloadData)
    mockDocument = MockDocument.new
    mockProject = mock("Project 1")
    mockDocument.stub!(:objectInProjectsAtIndex).with(1).and_return(mockProject)
    mc = OSX::MainController.alloc.init
    mc.setProjectsTableView(mockTableViewProjects)
    mc.setDocument(mockDocument)
    mockDraggingInfo = mock("NSDraggingInfo")
    mockDraggingInfo.stub!(:draggingSource).and_return(mockTableViewProjects)
    dropRow = 0
    dropOperation = OSX::NSTableViewDropAbove
    
    dragRows = OSX::NSMutableIndexSet.alloc.init
    dragRows.addIndex(1)
    pasteboard = OSX::NSPasteboard.pasteboardWithName("rspec pasteboard")
    
    mc.tableView_writeRowsWithIndexes_toPasteboard(
        mockTableViewProjects, dragRows, pasteboard
        )
        
    mockDraggingInfo.stub!(:draggingPasteboard).and_return(pasteboard)
    

    mockDocument.should_receive(:moveProject_toIndex).with(mockProject, dropRow)
    mockTableViewProjects.should_receive(:reloadData)
    
    mc.tableView_acceptDrop_row_dropOperation(
        mockTableViewProjects, mockDraggingInfo, dropRow, dropOperation
        ).should be_true
    
  end
  
end
