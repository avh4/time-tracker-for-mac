require File.dirname(__FILE__) + '/spec_helper'

require 'time'

describe OSX::TTTimeProvider do
  
  def rbTimeForNSDate(d)
    return Time.parse("" + d.description)
  end
  
  it "should return a valid today range" do
    provider = OSX::TTTimeProvider.alloc.init
    now = Time.new
    todayStart = rbTimeForNSDate(provider.todayStartTime)
    todayEnd = rbTimeForNSDate(provider.todayEndTime)
    
    check todayStart.year.should == now.year
    check todayStart.month.should == now.month
    check todayStart.day.should == now.day
    check todayStart.hour.should == 0
    check todayStart.min.should == 0
    check todayStart.sec.should == 0
    
    check todayEnd.year.should == now.year
    check todayEnd.month.should == now.month
    check todayEnd.day.should == now.day + 1
    check todayEnd.hour.should == 0
    check todayEnd.min.should == 0
    check todayEnd.sec.should == 0
  end
  
  it "should return a valid yesterday range" do
    provider = OSX::TTTimeProvider.alloc.init
    now = Time.new
    rangeStart = rbTimeForNSDate(provider.yesterdayStartTime)
    rangeEnd = rbTimeForNSDate(provider.yesterdayEndTime)
    
    check rangeStart.year.should == now.year
    check rangeStart.month.should == now.month
    check rangeStart.day.should == now.day - 1
    check rangeStart.hour.should == 0
    check rangeStart.min.should == 0
    check rangeStart.sec.should == 0
    
    check rangeEnd.year.should == now.year
    check rangeEnd.month.should == now.month
    check rangeEnd.day.should == now.day
    check rangeEnd.hour.should == 0
    check rangeEnd.min.should == 0
    check rangeEnd.sec.should == 0
  end
  
  it "should return a valid this week range" do
    provider = OSX::TTTimeProvider.alloc.init
    now = Time.new
    rangeStart = rbTimeForNSDate(provider.thisWeekStartTime)
    rangeEnd = rbTimeForNSDate(provider.thisWeekEndTime)

    puts rangeStart
    puts rangeEnd
    check rangeStart.strftime("%Y %U %H:%M:%S").should == now.strftime("%Y %U 00:00:00")
    check rangeStart.wday.should == 0
    
    check rangeEnd.strftime("%Y %H:%M:%S").should == now.strftime("%Y 00:00:00")
    check rangeEnd.strftime("%U").to_i.should == now.strftime("%U").to_i + 1
    check rangeEnd.wday.should == 0
  end
  
end