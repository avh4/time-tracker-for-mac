require File.dirname(__FILE__) + '/spec_helper'

describe OSX::TTask do
  
  it "should exist" do
    OSX::TTask
  end
  
  describe "a new task" do
    before(:each) do
      @task = OSX::TTask.alloc.init
    end
    it "should have zero time" do
      @task.totalTime.should == 0
    end
  end
  
  describe "with a single work period" do
    before(:each) do
      @seconds = 10*60
      @task = OSX::TTask.alloc.init
      @wp = MockWorkPeriod.new
      @wp.stub!(:totalTime).and_return(@seconds)
      @task.addWorkPeriod(@wp)
    end
    it "should return the work periods" do
      @task.workPeriods.should == [@wp]
    end
    it "should sum the work period's time" do
      @task.totalTime.should == @seconds
    end
    it "should sum the time correctly after the timer has updated a work period" do
      seconds_later = 20*60
      
      # Now the timer runs for a while...
      @wp.stub!(:totalTime).and_return(seconds_later)
      
      @task.totalTime.should == seconds_later
    end
  end
  
  describe "with multiple work periods" do
    before(:each) do
      @seconds = [10*60, 55*60 + 5]
      @task = OSX::TTask.alloc.init
      
      @wpEarly = MockWorkPeriod.new
      @wpLater = MockWorkPeriod.new
      
      @wpEarly.stub!(:totalTime).and_return(@seconds[0])
      @wpLater.stub!(:totalTime).and_return(@seconds[1])
      @wpEarly.stub!(:compare).with(@wpLater).and_return(OSX::NSOrderedAscending)
      @wpLater.stub!(:compare).with(@wpEarly).and_return(OSX::NSOrderedDescending)
      
      @task.addWorkPeriod(@wpLater)
      @task.addWorkPeriod(@wpEarly)
    end
    it "should sum the work periods' times" do
      @task.totalTime.should == @seconds[0] + @seconds[1]
    end
    it "should return the work periods in sorted order" do
      @task.workPeriods.should == [@wpEarly, @wpLater]
    end
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
    task.totalTimeInRangeFrom_to(rangeStart, rangeEnd).should == 5400
  end
  
end