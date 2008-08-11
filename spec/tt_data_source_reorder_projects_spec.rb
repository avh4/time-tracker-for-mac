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
    rowDataUnarchived.count.should == 1
    rowDataUnarchived.firstIndex.should == 1
    
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
        ).should equal OSX::NSDragOperationNone
    
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
        ).should equal OSX::NSDragOperationMove
    
  end
  
  it "should accept drops when moving rows within the table" do
    mc = OSX::MainController.alloc.init
    mockTableViewProjects = mock("NSTableView Projects")
    mc.setProjectsTableView(mockTableViewProjects)
    mockDraggingInfo = mock("NSDraggingInfo")
    dropRow = 0
    dropOperation = OSX::NSTableViewDropAbove
    
    mc.tableView_acceptDrop_row_dropOperation(
        mockTableViewProjects, mockDraggingInfo, dropRow, dropOperation
        ).should be_true
    
    # check that the row has been moved
    
  end
  
end
