require File.dirname(__FILE__) + '/spec_helper'
require 'time'

describe OSX::InspectorController do
  
  it "should display the start and end times from the given work period" do
    # Constants
    startTime = Time.parse("2008-10-08 20:33")
    endTime = Time.parse("2008-10-08 21:32")
    
    # Create
    ic = OSX::InspectorController.alloc.init
    mockStartPicker = MockDatePicker.new
    mockEndPicker = MockDatePicker.new
    ic.dpStartTime = mockStartPicker
    ic.dpEndTime = mockEndPicker
    mockWP = MockWorkPeriod.new
    mockWP.stub!(:startTime).and_return(startTime)
    mockWP.stub!(:endTime).and_return(endTime)
    
    # Mock expectations
    mockStartPicker.should_receive(:setDateValue) { |dv|
      rbTimeForNSDate(dv).should == startTime
    }
    mockEndPicker.should_receive(:setDateValue) { |dv|
      rbTimeForNSDate(dv).should == endTime
    }
    
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
  
  it "should update the work period start and end time" do
    # Constants
    newStartTime = OSX::NSDate.dateWithString("2008-10-08 20:33:00 -0700")
    newEndTime = OSX::NSDate.dateWithString("2008-10-08 21:32:00 -0700")
    
    # Create
    ic = OSX::InspectorController.alloc.init
    mockStartPicker = MockDatePicker.new
    mockEndPicker = MockDatePicker.new
    mockStartPicker.stub!(:dateValue).and_return(newStartTime)
    mockEndPicker.stub!(:dateValue).and_return(newEndTime)
    ic.dpStartTime = mockStartPicker
    ic.dpEndTime = mockEndPicker
    mockWP = MockWorkPeriod.new
    ic._setWorkPeriod(mockWP)
    
    # Mock expectations
    mockWP.should_receive(:setStartTime)#.with(newStartTime)
    mockWP.should_receive(:setEndTime)#.with(newEndTime)
    
    # Action
    ic.workPeriodChanged(nil)
    
    # Verify: mock expectations (above)
  end
  
end