require File.dirname(__FILE__) + '/spec_helper'

require 'time'
require 'rubygems'
require 'active_support'  # for Time#advance
require 'duration'

describe OSX::TTTimeProvider do
  
  before(:each) do
    @now = Time.new
    @yesterday = @now.advance(:days => -1)
    @tomorrow = @now.advance(:days => 1)
    @next_month = @now.advance(:months => 1)
    @last_month = @now.advance(:months => -1)
  end
    
  it "should return a valid today range" do
    provider = OSX::TTTimeProvider.alloc.init
    provider.setNow( Time.parse "Tue Jan 19 12:10:03 PST 2009" )
    check rbTimeForNSDate(provider.todayStartTime).should == Time.parse("Tue Jan 19 00:00:00 PST 2009")
    check rbTimeForNSDate(provider.todayEndTime).should ==   Time.parse("Tue Jan 20 00:00:00 PST 2009")    
  end
  
  it "should return a valid yesterday range" do
    provider = OSX::TTTimeProvider.alloc.init
    now = Time.new
    rangeStart = rbTimeForNSDate(provider.yesterdayStartTime)
    rangeEnd = rbTimeForNSDate(provider.yesterdayEndTime)
    
    check rangeStart.year.should == @yesterday.year
    check rangeStart.month.should == @yesterday.month
    check rangeStart.day.should == @yesterday.day
    check rangeStart.hour.should == 0
    check rangeStart.min.should == 0
    check rangeStart.sec.should == 0
    
    check rangeEnd.year.should == @now.year
    check rangeEnd.month.should == @now.month
    check rangeEnd.day.should == @now.day
    check rangeEnd.hour.should == 0
    check rangeEnd.min.should == 0
    check rangeEnd.sec.should == 0
  end
  
  it "should return a valid this week range" do
    provider = OSX::TTTimeProvider.alloc.init
    rangeStart = rbTimeForNSDate(provider.thisWeekStartTime)
    rangeEnd = rbTimeForNSDate(provider.thisWeekEndTime)

    check rangeStart.strftime("%Y %U %H:%M:%S").should == @now.strftime("%Y %U 00:00:00")
    check rangeStart.wday.should == 0
    
    check rangeEnd.strftime("%Y %H:%M:%S").should == @now.strftime("%Y 00:00:00")
    check rangeEnd.strftime("%U").to_i.should == @now.strftime("%U").to_i + 1
    check rangeEnd.wday.should == 0
  end
  
  it "should return a valid last week range" do
    provider = OSX::TTTimeProvider.alloc.init
    rangeStart = rbTimeForNSDate(provider.lastWeekStartTime)
    rangeEnd = rbTimeForNSDate(provider.lastWeekEndTime)

    check rangeStart.strftime("%Y %H:%M:%S").should == @now.strftime("%Y 00:00:00")
    check rangeStart.strftime("%U").to_i.should == @now.strftime("%U").to_i - 1
    check rangeStart.wday.should == 0
    
    check rangeEnd.strftime("%Y %H:%M:%S").should == @now.strftime("%Y 00:00:00")
    check rangeEnd.strftime("%U").to_i.should == @now.strftime("%U").to_i
    check rangeEnd.wday.should == 0
  end
  
  it "should return a valid this month range" do
    provider = OSX::TTTimeProvider.alloc.init
    rangeStart = rbTimeForNSDate(provider.thisMonthStartTime)
    rangeEnd = rbTimeForNSDate(provider.thisMonthEndTime)

    check rangeStart.strftime("%Y %H:%M:%S").should == @now.strftime("%Y 00:00:00")
    check rangeStart.month.should == @now.month
    check rangeStart.day.should == 1
    
    check rangeEnd.strftime("%Y %H:%M:%S").should == (@next_month).strftime("%Y 00:00:00")
    check rangeEnd.month.should == @next_month.month
    check rangeEnd.day.should == 1
  end
  
  it "should return a valid last month range" do
    provider = OSX::TTTimeProvider.alloc.init
    rangeStart = rbTimeForNSDate(provider.lastMonthStartTime)
    rangeEnd = rbTimeForNSDate(provider.lastMonthEndTime)
    
    check rangeStart.year.should == @last_month.year
    check rangeStart.month.should == @last_month.month
    check rangeStart.day.should == 1
    check rangeStart.hour.should == 0
    check rangeStart.min.should == 0
    check rangeStart.sec.should == 0
    

    check rangeEnd.year.should == @now.year
    check rangeEnd.month.should == @now.month
    check rangeEnd.day.should == 1
    check rangeEnd.hour.should == 0
    check rangeEnd.min.should == 0
    check rangeEnd.sec.should == 0
  end
  
end