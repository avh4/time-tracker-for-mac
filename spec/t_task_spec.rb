require File.dirname(__FILE__) + '/spec_helper'
require "Application.bundle"

require 'date'

describe OSX::TTask do
  
  # We must define RubyCocoa objects for for certain mock objects
  # so that we can specify the return type for methods that do not
  # return objects
  class MockWorkPeriod < OSX::NSObject
    objc_method :totalTime, "i@:"
    objc_method :compare, "i@:@"
    objc_method :totalTimeInRangeFrom_to, "i@:@@"
  end
  
  
  it "should exist" do
    OSX::TTask
  end
  
  it "should initially have zero time" do
    task = OSX::TTask.alloc.init
    task.totalTime.should == 0
  end
  
  it "should sum the time of a single work period" do
    seconds = 10*60
    task = OSX::TTask.alloc.init
    
    wp = MockWorkPeriod.new
    wp.stub!(:totalTime).and_return(seconds)
    task.addWorkPeriod(wp)
    
    task.totalTime.should == seconds
  end
  
  it "should sum the time of multiple work periods" do
    seconds = [10*60, 55*60 + 5]
    task = OSX::TTask.alloc.init
    
    wps = [MockWorkPeriod.new, MockWorkPeriod.new]
    wps[0].stub!(:totalTime).and_return(seconds[0])
    wps[1].stub!(:totalTime).and_return(seconds[1])
    
    task.addWorkPeriod(wps[0])
    task.addWorkPeriod(wps[1])
    
    task.totalTime.should == seconds[0] + seconds[1]
  end
  
  it "should sum the time correctly after the timer has updated a work period" do
    seconds = 10*60
    seconds_later = 20*60
    task = OSX::TTask.alloc.init
    
    wp = MockWorkPeriod.new
    wp.stub!(:totalTime).and_return(seconds)
    task.addWorkPeriod(wp)
    
    # Now the timer runs for a while...
    wp.stub!(:totalTime).and_return(seconds_later)
    
    task.totalTime.should == seconds_later
  end
  
  it "should always return the work periods in sorted order" do
    task = OSX::TTask.alloc.init
    wpEarly = MockWorkPeriod.new
    wpLater = MockWorkPeriod.new
    wpEarly.stub!(:compare).with(wpLater).and_return(OSX::NSOrderedAscending)
    wpLater.stub!(:compare).with(wpEarly).and_return(OSX::NSOrderedDescending)
    task.addWorkPeriod(wpLater)
    task.addWorkPeriod(wpEarly)
    
    task.workPeriods.objectAtIndex(0).should equal(wpEarly)
    task.workPeriods.objectAtIndex(1).should equal(wpLater)
  end
  
  it "should return the work periods in a specified time interval" do
    rangeStart = Time.parse("2008-10-11 00:00")
    rangeEnd = Time.parse("2008-10-12 00:00")
    
    task = OSX::TTask.alloc.init
    wpBefore = MockWorkPeriod.new
    wpBefore.stub!(:totalTimeInRangeFrom_to).and_return(0)
    wpDuring = MockWorkPeriod.new
    wpDuring.stub!(:totalTimeInRangeFrom_to).and_return(5400)
    wpAfter = MockWorkPeriod.new
    wpAfter.stub!(:totalTimeInRangeFrom_to).and_return(0)
    
    task.addWorkPeriod(wpBefore);
    task.addWorkPeriod(wpDuring);
    task.addWorkPeriod(wpAfter);
    
    task.workPeriodsInRangeFrom_to(rangeStart, rangeEnd).size.should equal(1)
    task.workPeriodsInRangeFrom_to(rangeStart, rangeEnd).objectAtIndex(0).should equal(wpDuring)
    task.totalTimeInRangeFrom_to(rangeStart, rangeEnd).should equal(5400)
  end
  
end