require File.dirname(__FILE__) + '/spec_helper'
require "Application.bundle"

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
  
  
end