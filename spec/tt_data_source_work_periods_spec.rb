require File.dirname(__FILE__) + '/spec_helper'

require "TTDataSource.bundle"
OSX::ns_import :TTDataSource

describe OSX::TTDataSource do
  
  it "should return Work Date values" do
    ds = OSX::TTDataSource.alloc.init
    mockWP = mock("TWorkPeriod")
    ds.setWorkPeriod(mockWP)
    mockTable = mock("NSTableView")
    mockColumn = mock("NSTableColumn")
    
    mockWP.should_recieve(:startTime).and_return(OSX::NSDate.date)
    
    date = ds.tableView_objectValueForTableColumn_row(mockTable, mockColumn, 0)
    
    date.should == "12/12/08"
    
  end
  
  it "should return Start time values" do
  end
  
  it "should return End time values" do
  end
  
  it "should return Duration values" do
  end
  
end