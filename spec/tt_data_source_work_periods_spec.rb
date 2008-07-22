require File.dirname(__FILE__) + '/spec_helper'

require "TTDataSource.bundle"
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
  
  it "should return Work Date values" do
    # Set up constants
    START_TIME = Time.now
    
    # Set up objects
    mockWP = mock("TWorkPeriod")
    mockTable = mock("NSTableView")
    mockColumn = mock("NSTableColumn")
    mockColumn.stub!(:identifier).and_return(TT_WP_COL_DATE)
    ds = OSX::TTDataSource.alloc.init
    ds.setWorkPeriods( [mockWP] )
    
    # Set up expectations
    mockWP.should_receive(:startTime).and_return(START_TIME)
    
    # Perform the test
    date = ds.tableView_objectValueForTableColumn_row(mockTable, mockColumn, 0)
    
    # Check assertations
    date.should == START_TIME.strftime("%m/%d/%Y")
  end
  
  it "should return Start time values" do
    # Set up constants
    START_TIME = Time.now
    
    # Set up objects
    mockWP = mock("TWorkPeriod")
    mockTable = mock("NSTableView")
    mockColumn = mock("NSTableColumn")
    mockColumn.stub!(:identifier).and_return(TT_WP_COL_START_TIME)
    ds = OSX::TTDataSource.alloc.init
    ds.setWorkPeriods( [mockWP] )
    
    # Set up expectations
    mockWP.should_receive(:startTime).and_return(START_TIME)
    
    # Perform the test
    date = ds.tableView_objectValueForTableColumn_row(mockTable, mockColumn, 0)
    
    # Check assertations
    date.should == START_TIME.strftime("%H:%M:%S")
  end
  
  it "should return End time values" do
    # Set up constants
    END_TIME = Time.now
    
    # Set up objects
    mockWP = mock("TWorkPeriod")
    mockTable = mock("NSTableView")
    mockColumn = mock("NSTableColumn")
    mockColumn.stub!(:identifier).and_return(TT_WP_COL_END_TIME)
    ds = OSX::TTDataSource.alloc.init
    ds.setWorkPeriods( [mockWP] )
    
    # Set up expectations
    mockWP.should_receive(:endTime).and_return(END_TIME)
    
    # Perform the test
    date = ds.tableView_objectValueForTableColumn_row(mockTable, mockColumn, 0)
    
    # Check assertations
    date.should == END_TIME.strftime("%H:%M:%S")
  end
  
  it "should return Duration values" do
    # Set up constants
    DURATION = 61
    DURATION_STRING = "00:01:01"
    
    # Set up objects
    mockWP = MockWorkPeriod.new
    mockTable = mock("NSTableView")
    mockColumn = mock("NSTableColumn")
    mockColumn.stub!(:identifier).and_return(TT_WP_COL_DURATION)
    ds = OSX::TTDataSource.alloc.init
    ds.setWorkPeriods( [mockWP] )
    
    # Set up expectations
    mockWP.should_receive(:totalTime).and_return(DURATION)
    
    # Perform the test
    duration = ds.tableView_objectValueForTableColumn_row(mockTable, mockColumn, 0)
    
    # Check assertations
    duration.should == DURATION_STRING
  end
  
end