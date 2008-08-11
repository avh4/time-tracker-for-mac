require "Application.bundle"

describe OSX::MainController do
  
  it "should allow dragging within the table" do
    mc = OSX::MainController.alloc.init
    mockTableViewProjects = mock("NSTableView Projects")
    mockDraggingInfo = mock("NSDraggingInfo")
    dropRow = 0
    dropOperation = OSX::NSTableViewDropAbove
    dragRows = OSX::NSMutableIndexSet.alloc.init
    dragRows.addIndex(1)
    mockPasteboard = mock("NSPasteboard")
    
    mc.tableView_writeRowsWithIndexes_toPasteboard(
        mockTableViewProjects, dragRows, mockPasteboard
        ).should be_true
    
    mc.tableView_validateDrop_proposedRow_proposedDropOperation(
        mockTableViewProjects, mockDraggingInfo, dropRow, dropOperation
        ).should equal OSX::NSDragOperationMove
    
    mc.tableView_acceptDrop_row_dropOperation(
        mockTableViewProjects, mockDraggingInfo, dropRow, dropOperation
        ).should be_true
    
    # check that the row has been moved
    
  end
  
end
