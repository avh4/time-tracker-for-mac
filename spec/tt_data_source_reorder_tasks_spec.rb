require "Application.bundle"

describe OSX::MainController do
  
  it "should configure the tasks table to accept drops" do
    mc = OSX::MainController.alloc.init
    mockTableViewTasks = mock("NSTableView Tasks")
    mc.setTasksTableView(mockTableViewTasks)

    mockTableViewTasks.stub!(:reloadData)
    
    mockTableViewTasks.should_receive(:registerForDraggedTypes)

    mc.awakeFromNib
  end
  
  it "should allow table rows to be dragged" do
    mc = OSX::MainController.alloc.init
    mockTableViewTasks = mock("NSTableView Tasks")
    mc.setTasksTableView(mockTableViewTasks)
    dragRows = OSX::NSMutableIndexSet.alloc.init
    dragRows.addIndex(1)
    pasteboard = OSX::NSPasteboard.pasteboardWithName("rspec pasteboard")
    
    mc.tableView_writeRowsWithIndexes_toPasteboard(
        mockTableViewTasks, dragRows, pasteboard
        ).should be_true

    # The pastboard must have the TIME_TRACKER_TASK_ROWS type
    types = pasteboard.types
    types.index("TIME_TRACKER_TASK_ROWS").should_not be_nil
    
    # Check the contents of the TIME_TRACKER_TASK_ROWS data
    rowData = pasteboard.dataForType("TIME_TRACKER_TASK_ROWS")
    rowDataUnarchived = OSX::NSKeyedUnarchiver.unarchiveObjectWithData(rowData)
    rowDataUnarchived.isKindOfClass(OSX::NSIndexSet).should be_true
    rowDataUnarchived.count.should equal(1)
    rowDataUnarchived.firstIndex.should equal(1)
    
  end
  
  it "should reject drags from other sources" do
    mc = OSX::MainController.alloc.init
    mockTableViewTasks = mock("NSTableView Tasks")
    mc.setTasksTableView(mockTableViewTasks)
    mockDraggingInfo = mock("NSDraggingInfo")
    dropRow = 0
    dropOperation = OSX::NSTableViewDropAbove
    mockOtherDragSource = mock("Other drag source")
    
    mockDraggingInfo.stub!(:draggingSource).and_return(mockOtherDragSource)
    
    mc.tableView_validateDrop_proposedRow_proposedDropOperation(
        mockTableViewTasks, mockDraggingInfo, dropRow, dropOperation
        ).should equal(OSX::NSDragOperationNone)
    
  end
  
  it "should validate drops when moving rows within the table" do
    mc = OSX::MainController.alloc.init
    mockTableViewTasks = mock("NSTableView Tasks")
    mc.setTasksTableView(mockTableViewTasks)
    mockDraggingInfo = mock("NSDraggingInfo")
    dropRow = 0
    dropOperation = OSX::NSTableViewDropAbove
    
    mockDraggingInfo.stub!(:draggingSource).and_return(mockTableViewTasks)
    
    mockTableViewTasks.should_receive(:setDropRow_dropOperation)
    
    mc.tableView_validateDrop_proposedRow_proposedDropOperation(
        mockTableViewTasks, mockDraggingInfo, dropRow, dropOperation
        ).should equal(OSX::NSDragOperationMove)
    
  end
  
  class MockDocument < OSX::NSObject
    objc_method :objectInProjectsAtIndex, "@@:i"
    objc_method :moveProject_toIndex, "v@:@i"
  end
  
  
  it "should accept drops when moving rows within the table" do
    mockTableViewTasks = mock("NSTableView Tasks")
    mockTableViewTasks.stub!(:reloadData)
    mockDocument = MockDocument.new
    mockProject = mock("Project 1")
    mockTask = mock("Task 1.2")
    mockDocument.stub!(:objectInProjectsAtIndex).with(0).and_return(mockProject)
    mockProject.stub!(:objectInTasksAtIndex).with(1).and_return(mockTask)
    mc = OSX::MainController.alloc.init
    mc.setTasksTableView(mockTableViewTasks)
    mc.setDocument(mockDocument)
    mc.setCurrentProject(mockProject)
    mockDraggingInfo = mock("NSDraggingInfo")
    mockDraggingInfo.stub!(:draggingSource).and_return(mockTableViewTasks)
    dropRow = 0
    dropOperation = OSX::NSTableViewDropAbove
    
    dragRows = OSX::NSMutableIndexSet.alloc.init
    dragRows.addIndex(1)
    pasteboard = OSX::NSPasteboard.pasteboardWithName("rspec pasteboard")
    
    mc.tableView_writeRowsWithIndexes_toPasteboard(
        mockTableViewTasks, dragRows, pasteboard
        )
        
    mockDraggingInfo.stub!(:draggingPasteboard).and_return(pasteboard)
    

    mockProject.should_receive(:moveTask_toIndex).with(mockTask, dropRow)
    mockTableViewTasks.should_receive(:reloadData)
    
    mc.tableView_acceptDrop_row_dropOperation(
        mockTableViewTasks, mockDraggingInfo, dropRow, dropOperation
        ).should be_true
    
  end
  
end
