require File.dirname(__FILE__) + '/spec_helper'

describe OSX::InspectorController do
  
  it "should display the start and end times from the given work period" do
    # Constants
    startTime = Time.parse("2008-10-08 20:33")
    endTime = Time.parse("2008-10-08 21:32")
    
    # Create
    ic = OSX::InspectorController.alloc.init
    mockStartPicker = mock("NSDatePicker start time")
    mockEndPicker = mock("NSDatePicker end time")
    ic.dpStartTime = mockStartPicker
    ic.dpEndTime = mockEndPicker
    mockWP = mock("WorkPeriod")
    mockWP.stub!(:startTime).and_return(startTime)
    mockWP.stub!(:endTime).and_return(endTime)
    
    # Mock expectations
    mockStartPicker.should_recieve(:setDateValue).with(startTime)
    mockEndPicker.should_recieve(:setDateValue).with(endTime)
    
    # Action
    ic.setWorkPeriod(mockWP)
    
    # Verify: mock expectations (above)
  end
  
  it "should display disabled when no work period is set" do
    pending
  end
  
  it "should update the work period start time" do
    pending
  end
  
  it "should update the work period end time" do
    pending
  end
  
end