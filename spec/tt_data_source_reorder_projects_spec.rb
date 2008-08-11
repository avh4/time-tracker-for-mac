require "Application.bundle"

describe OSX::MainController do
  
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
  
  it "should allow dragging within the table" do
    mc = OSX::MainController.alloc.init
    mockTableViewProjects = mock("NSTableView Projects")
    mockDraggingInfo = mock("NSDraggingInfo")
    dropRow = 0
    dropOperation = OSX::NSTableViewDropAbove
    
    mc.tableView_validateDrop_proposedRow_proposedDropOperation(
        mockTableViewProjects, mockDraggingInfo, dropRow, dropOperation
        ).should equal OSX::NSDragOperationMove
    
    mc.tableView_acceptDrop_row_dropOperation(
        mockTableViewProjects, mockDraggingInfo, dropRow, dropOperation
        ).should be_true
    
    # check that the row has been moved
    
  end
  
end
