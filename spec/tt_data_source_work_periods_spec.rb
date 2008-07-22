require File.dirname(__FILE__) + '/spec_helper'

require "Application.bundle"
OSX::ns_import :TTDataSource

describe OSX::TTDataSource do
  
  # We must define RubyCocoa objects for for certain mock objects
  # so that we can specify the return type for methods that do not
  # return objects
  class MockWorkPeriod < OSX::NSObject
    objc_method :totalTime, "i@:"
  end
  
  TT_WP_COL_DATE = "Date"
  TT_WP_COL_START_TIME = "StartTime"
  TT_WP_COL_END_TIME = "EndTime"
  TT_WP_COL_DURATION = "Duration"
  
  before do
    START_TIME = Time.now
    END_TIME = START_TIME + 61
    DURATION = 61
    
    MOCK_TABLE = mock("NSTableView")

    MOCK_WP = MockWorkPeriod.new
    MOCK_WP.stub!(:startTime).and_return(START_TIME)
    MOCK_WP.stub!(:endTime).and_return(END_TIME)
    MOCK_WP.stub!(:totalTime).and_return(DURATION)
  end
  
  it "should return column values" do
    # Set up objects
    mockColumn = mock("NSTableColumn")
    mockColumn.stub!(:identifier).and_return(TT_WP_COL_DATE)
    ds = OSX::TTDataSource.alloc.init
    ds.setWorkPeriods( [MOCK_WP] )
    
    # Perform the test
    ds.tableView_objectValueForTableColumn_row(MOCK_TABLE, mockColumn, 0)\
      .should == START_TIME.strftime("%m/%d/%Y")
    
  end
  
  it "should return Start time values" do
    # Set up objects
    mockColumn = mock("NSTableColumn")
    mockColumn.stub!(:identifier).and_return(TT_WP_COL_START_TIME)
    ds = OSX::TTDataSource.alloc.init
    ds.setWorkPeriods( [MOCK_WP] )
    
    # Perform the test
    ds.tableView_objectValueForTableColumn_row(MOCK_TABLE, mockColumn, 0)\
      .should == START_TIME.strftime("%H:%M:%S")
  end
  
  it "should return End time values" do
    # Set up objects
    mockColumn = mock("NSTableColumn")
    mockColumn.stub!(:identifier).and_return(TT_WP_COL_END_TIME)
    ds = OSX::TTDataSource.alloc.init
    ds.setWorkPeriods( [MOCK_WP] )
    
    # Perform the test
    ds.tableView_objectValueForTableColumn_row(MOCK_TABLE, mockColumn, 0)\
      .should == END_TIME.strftime("%H:%M:%S")
  end
  
  it "should return Duration values" do
    # Set up objects
    mockColumn = mock("NSTableColumn")
    mockColumn.stub!(:identifier).and_return(TT_WP_COL_DURATION)
    ds = OSX::TTDataSource.alloc.init
    ds.setWorkPeriods( [MOCK_WP] )
    
    # Perform the test
    ds.tableView_objectValueForTableColumn_row(MOCK_TABLE, mockColumn, 0)\
      .should == "00:01:01"
  end
  
end