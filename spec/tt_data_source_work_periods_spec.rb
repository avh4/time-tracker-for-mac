require File.dirname(__FILE__) + '/spec_helper'

describe OSX::TTDataSource do
  
  it "should return Work Date values" do
    # Set up constants
    START_TIME = Time.now
    
    # Set up objects
    mockWP = mock("TWorkPeriod")
    mockTable = mock("NSTableView")
    mockColumn = mock("NSTableColumn")
    mockColumn.stub!(:identifier).and_return("Date")
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
  end
  
  it "should return End time values" do
  end
  
  it "should return Duration values" do
  end
  
end