require File.dirname(__FILE__) + '/spec_helper'

require "Application.bundle"
OSX::ns_import :TTDataSource

describe OSX::TTDataSource do
  
  TT_WP_COL_DATE = "Date"
  TT_WP_COL_START_TIME = "StartTime"
  TT_WP_COL_END_TIME = "EndTime"
  TT_WP_COL_DURATION = "Duration"
  
  before do
    @startTime = Time.now
    @endTime = @startTime + 61
    @duration = 61
    
    @mockTable = mock("NSTableView")

    @mockWorkPeriod = MockWorkPeriod.new
    @mockWorkPeriod.stub!(:startTime).and_return(@startTime)
    @mockWorkPeriod.stub!(:endTime).and_return(@endTime)
    @mockWorkPeriod.stub!(:totalTime).and_return(@duration)
  end
  
  it "should return column values" do
    # Set up objects
    mockColumn = mock("NSTableColumn")
    mockColumn.stub!(:identifier).and_return(TT_WP_COL_DATE)
    ds = OSX::TTDataSource.alloc.init
    ds.setWorkPeriods( [@mockWorkPeriod] )
    
    # Perform the test
    ds.tableView_objectValueForTableColumn_row(@mockTable, mockColumn, 0)\
      .should == @startTime.strftime("%m/%d/%Y")
    
  end
  
  it "should return Start time values" do
    # Set up objects
    mockColumn = mock("NSTableColumn")
    mockColumn.stub!(:identifier).and_return(TT_WP_COL_START_TIME)
    ds = OSX::TTDataSource.alloc.init
    ds.setWorkPeriods( [@mockWorkPeriod] )
    
    # Perform the test
    ds.tableView_objectValueForTableColumn_row(@mockTable, mockColumn, 0)\
      .should == @startTime.strftime("%H:%M:%S")
  end
  
  it "should return End time values" do
    # Set up objects
    mockColumn = mock("NSTableColumn")
    mockColumn.stub!(:identifier).and_return(TT_WP_COL_END_TIME)
    ds = OSX::TTDataSource.alloc.init
    ds.setWorkPeriods( [@mockWorkPeriod] )
    
    # Perform the test
    ds.tableView_objectValueForTableColumn_row(@mockTable, mockColumn, 0)\
      .should == @endTime.strftime("%H:%M:%S")
  end
  
  it "should return Duration values" do
    # Set up objects
    mockColumn = mock("NSTableColumn")
    mockColumn.stub!(:identifier).and_return(TT_WP_COL_DURATION)
    ds = OSX::TTDataSource.alloc.init
    ds.setWorkPeriods( [@mockWorkPeriod] )
    
    # Perform the test
    ds.tableView_objectValueForTableColumn_row(@mockTable, mockColumn, 0)\
      .should == "00:01:01"
  end
  
end