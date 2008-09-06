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
    
    todayStart.year.should == now.year
    todayStart.month.should == now.month
    todayStart.day.should == now.day
    todayStart.hour.should == 0
    todayStart.min.should == 0
    todayStart.sec.should == 0
    
    todayEnd.year.should == now.year
    todayEnd.month.should == now.month
    todayEnd.day.should == now.day + 1
    todayEnd.hour.should == 0
    todayEnd.min.should == 0
    todayEnd.sec.should == 0
  end
  
  it "should return a valid yesterday range" do
    provider = OSX::TTTimeProvider.alloc.init
    now = Time.new
    rangeStart = rbTimeForNSDate(provider.yesterdayStartTime)
    rangeEnd = rbTimeForNSDate(provider.yesterdayEndTime)
    
    rangeStart.year.should == now.year
    rangeStart.month.should == now.month
    rangeStart.day.should == now.day - 1
    rangeStart.hour.should == 0
    rangeStart.min.should == 0
    rangeStart.sec.should == 0
    
    rangeEnd.year.should == now.year
    rangeEnd.month.should == now.month
    rangeEnd.day.should == now.day
    rangeEnd.hour.should == 0
    rangeEnd.min.should == 0
    rangeEnd.sec.should == 0
  end
  
  it "should return a valid this week range" do
    provider = OSX::TTTimeProvider.alloc.init
    now = Time.new
    rangeStart = rbTimeForNSDate(provider.thisWeekStartTime)
    rangeEnd = rbTimeForNSDate(provider.thisWeekEndTime)

    puts rangeStart
    puts rangeEnd
    rangeStart.strftime("%Y %U %H:%M:%S").should == now.strftime("%Y %U 00:00:00")
    rangeStart.wday.should == 0
    
    rangeEnd.strftime("%Y %H:%M:%S").should == now.strftime("%Y 00:00:00")
    rangeEnd.strftime("%U").to_i.should == now.strftime("%U").to_i + 1
    rangeEnd.wday.should == 0
  end
  
end