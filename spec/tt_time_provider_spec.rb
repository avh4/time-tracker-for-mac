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
    puts todayEnd
    
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
  
end