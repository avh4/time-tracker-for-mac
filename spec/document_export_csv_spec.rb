require File.dirname(__FILE__) + '/spec_helper'

describe OSX::TTDocumentV1 do
  
  it "should export an empty CSV file" do
    doc = OSX::TTDocumentV1.alloc.init
    
    data, error = doc.dataOfType_error("CSV")
    error.should be_nil
    
    data_string = OSX::NSString.alloc.initWithData_encoding(data, OSX::NSASCIIStringEncoding)
    
    data_string.should == (%Q{
      Date,Start time,End time,Duration (seconds),Project,Task
    }.gsub!(/^\s*/, ''))
  end
  
  it "should export a simple CSV file" do
    doc = OSX::TTDocumentV1.alloc.init
    
    pr1 = mock("Project 1")
    pr2 = mock("Project 2")
    t11 = mock("Task 1.1")
    t12 = mock("Task 1.2")
    t21 = mock("Task 2.1")
    w111 = MockWorkPeriod.new
    w112 = MockWorkPeriod.new
    w121 = MockWorkPeriod.new
    w211 = MockWorkPeriod.new
    
    pr1.stub!(:tasks).and_return( [t11, t12] )
    pr2.stub!(:tasks).and_return( [t21] )
    t11.stub!(:workPeriods).and_return( [w111, w112] )
    t12.stub!(:workPeriods).and_return( [w121] )
    t21.stub!(:workPeriods).and_return( [w211] )
    pr1.stub!(:name).and_return("Project 1")
    pr2.stub!(:name).and_return("Project 2")
    t11.stub!(:name).and_return("Task 1.1")
    t12.stub!(:name).and_return("Task 1.2")
    t21.stub!(:name).and_return("Task 2.1")
    w111.stub!(:totalTime).and_return( 10*60 )
    w112.stub!(:totalTime).and_return(  5*60 + 10 )
    w121.stub!(:totalTime).and_return(  5*60 + 10 )
    w211.stub!(:totalTime).and_return(  5*60 + 10 )
    w111.stub!(:startTime).and_return( Time.local(2008,1,1, 10,20,00) )
    w112.stub!(:startTime).and_return( Time.local(2008,1,1, 10,35,00) )
    w121.stub!(:startTime).and_return( Time.local(2008,1,3, 10,35,00) )
    w211.stub!(:startTime).and_return( Time.local(2008,2,4, 10,35,00) )
    w111.stub!(:endTime).and_return( Time.local(2008,1,1, 10,30,00) )
    w112.stub!(:endTime).and_return( Time.local(2008,1,1, 10,40,10) )
    w121.stub!(:endTime).and_return( Time.local(2008,1,3, 10,40,10) )
    w211.stub!(:endTime).and_return( Time.local(2008,2,4, 10,40,10) )
    
    doc.setProjects( [pr1, pr2] )
    
    data, error = doc.dataOfType_error("CSV")
    error.should be_nil
    
    data_string = OSX::NSString.alloc.initWithData_encoding(data, OSX::NSASCIIStringEncoding)
    
    data_string.should == (%Q{
      Date,Start time,End time,Duration (seconds),Project,Task
      2008-01-01,10:20,10:30,600,Project 1,Task 1.1
      2008-01-01,10:35,10:40,310,Project 1,Task 1.1
      2008-01-03,10:35,10:40,310,Project 1,Task 1.2
      2008-02-04,10:35,10:40,310,Project 2,Task 2.1
    }.gsub!(/^\s*/, ''))
  end

end