require File.dirname(__FILE__) + '/spec_helper'

describe OSX::InspectorController do
  
  it "should display the start and end times from the given work period" do
    # Constants
    startTime = OSX::NSDate.dateWithString("2008-10-08 20:33")
    endTime = OSX::NSDate.dateWithString("2008-10-08 21:32")
    
    # Create
    ic = OSX::InspectorController.alloc.init
    mockStartPicker = MockDatePicker.new
    mockEndPicker = MockDatePicker.new
    ic.dpStartTime = mockStartPicker
    ic.dpEndTime = mockEndPicker
    mockWP = mock("WorkPeriod")
    mockWP.stub!(:startTime).and_return(startTime)
    mockWP.stub!(:endTime).and_return(endTime)
    
    # Mock expectations
    mockStartPicker.should_receive(:setDateValue).with(startTime)
    mockEndPicker.should_receive(:setDateValue).with(endTime)
    
    # Action
    ic.setWorkPeriod(mockWP)
    
    # Verify: mock expectations (above)
  end
  
  it "should display disabled when no work period is set" do
    # Create
    ic = OSX::InspectorController.alloc.init
    mockStartPicker = MockDatePicker.new
    mockEndPicker = MockDatePicker.new
    ic.dpStartTime = mockStartPicker
    ic.dpEndTime = mockEndPicker
    
    # Mock expectations
    mockStartPicker.should_receive(:setEnabled).with(false)
    mockEndPicker.should_receive(:setEnabled).with(false)
    
    # Action
    ic.setWorkPeriod(nil)

    # Verify: mock expectations (above)
  end
  
  it "should update the work period start time" do
    pending
  end
  
  it "should update the work period end time" do
    pending
  end
  
end