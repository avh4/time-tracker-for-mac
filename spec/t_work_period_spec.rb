require File.dirname(__FILE__) + '/spec_helper'
require 'time'

describe OSX::TWorkPeriod do
  
  it "should compare equal to a work period with equal start date" do
    wp = OSX::TWorkPeriod.alloc.init
    wp.setStartTime(Time.parse("2008-08-11 11:30"))
    equalWp = OSX::TWorkPeriod.alloc.init
    equalWp.setStartTime(Time.parse("2008-08-11 11:30"))
    
    wp.compare(equalWp).should equal(OSX::NSOrderedSame)
  end
  
  it "should compare ascending to a work period with later start date" do
    wp = OSX::TWorkPeriod.alloc.init
    wp.setStartTime(Time.parse("2008-08-11 11:30"))
    equalWp = OSX::TWorkPeriod.alloc.init
    equalWp.setStartTime(Time.parse("2008-08-12 12:30"))
    
    wp.compare(equalWp).should equal(OSX::NSOrderedAscending)
  end

  it "should compare descending to a work period with earlier start date" do
    wp = OSX::TWorkPeriod.alloc.init
    wp.setStartTime(Time.parse("2008-08-11 11:30"))
    equalWp = OSX::TWorkPeriod.alloc.init
    equalWp.setStartTime(Time.parse("2008-08-10 10:30"))
    
    wp.compare(equalWp).should equal(OSX::NSOrderedDescending)
  end
  
  describe "filtering" do
    
    before(:each) do
      @rangeStart = Time.parse("2008-10-10 00:00")
      @rangeEnd = Time.parse("2008-10-11 00:00")
    end
    
    it "should calculate total time within a specified range (within the range)" do
      wp = OSX::TWorkPeriod.alloc.init
      wp.setStartTime(Time.parse("2008-10-10 12:00"))
      wp.setEndTime(Time.parse("2008-10-10 12:30"))
      wp.totalTimeInRangeFrom_to(@rangeStart, @rangeEnd).should == 30*60
    end
    
    it "should calculate total time within a specified range (overlaping the start)" do
      wp = OSX::TWorkPeriod.alloc.init
      wp.setStartTime(Time.parse("2008-10-09 12:00"))
      wp.setEndTime(Time.parse("2008-10-10 00:30"))
      wp.totalTimeInRangeFrom_to(@rangeStart, @rangeEnd).should == 30*60
    end
    
    it "should calculate total time within a specified range (overlaping the end)" do
      wp = OSX::TWorkPeriod.alloc.init
      wp.setStartTime(Time.parse("2008-10-10 23:30"))
      wp.setEndTime(Time.parse("2008-10-11 12:30"))
      wp.totalTimeInRangeFrom_to(@rangeStart, @rangeEnd).should == 30*60
    end
    
    it "should calculate total time within a specified range (outside the range)" do
      wp = OSX::TWorkPeriod.alloc.init
      wp.setStartTime(Time.parse("2008-10-11 12:00"))
      wp.setEndTime(Time.parse("2008-10-11 12:30"))
      wp.totalTimeInRangeFrom_to(@rangeStart, @rangeEnd).should == 0
    end
    
  end
  
end