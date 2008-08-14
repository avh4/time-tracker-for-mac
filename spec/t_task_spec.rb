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
  
end