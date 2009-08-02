require File.dirname(__FILE__) + '/spec_helper'

describe OSX::TTTimeProvider do
  
  it "should return a valid today range" do
    provider = OSX::TTTimeProvider.alloc.init
    provider.setNow( Time.parse("Mon Jan 19 12:10:03 PST 2009") )
    check rbTimeForNSDate(provider.todayStartTime).should == Time.parse("Sun Jan 19 00:00:00 PST 2009")
    check rbTimeForNSDate(provider.todayEndTime).should ==   Time.parse("Tue Jan 20 00:00:00 PST 2009")
  end
  
  it "should return a valid yesterday range" do
    provider = OSX::TTTimeProvider.alloc.init
    provider.setNow( Time.parse("Mon Jan 19 12:10:03 PST 2009") )
    check rbTimeForNSDate(provider.yesterdayStartTime).should == Time.parse("Sun Jan 18 00:00:00 PST 2009")
    check rbTimeForNSDate(provider.yesterdayEndTime).should ==   Time.parse("Mon Jan 19 00:00:00 PST 2009")
  end
  
  it "should return a valid this week range" do
    provider = OSX::TTTimeProvider.alloc.init
    provider.setNow( Time.parse("Mon Jan 12 12:10:03 PST 2009") )
    check rbTimeForNSDate(provider.thisWeekStartTime).should == Time.parse("Sun Jan 11 00:00:00 PST 2009")
    check rbTimeForNSDate(provider.thisWeekEndTime).should ==   Time.parse("Sun Jan 18 00:00:00 PST 2009")
  end
  
  it "should return a valid last week range" do
    provider = OSX::TTTimeProvider.alloc.init
    provider.setNow( Time.parse("Mon Jan 12 12:10:03 PST 2009") )
    check rbTimeForNSDate(provider.lastWeekStartTime).should == Time.parse("Sun Jan 4 00:00:00 PST 2009")
    check rbTimeForNSDate(provider.lastWeekEndTime).should ==   Time.parse("Sun Jan 11 00:00:00 PST 2009")
  end
  
  it "should return a valid 'week before last' range" do
    provider = OSX::TTTimeProvider.alloc.init
    provider.setNow( Time.parse("Mon Jan 12 12:10:03 PST 2009") )
    check rbTimeForNSDate(provider.weekBeforeLastStartTime).should == Time.parse("Sun Dec 28 00:00:00 PST 2008")
    check rbTimeForNSDate(provider.weekBeforeLastEndTime).should ==   Time.parse("Sun Jan 4 00:00:00 PST 2009")
  end

  it "should return a valid this month range" do
    provider = OSX::TTTimeProvider.alloc.init
    provider.setNow( Time.parse("Fri Dec 12 12:10:03 PST 2008") )
    check rbTimeForNSDate(provider.thisMonthStartTime).should == Time.parse("Mon Dec 1 00:00:00 PST 2008")
    check rbTimeForNSDate(provider.thisMonthEndTime).should ==   Time.parse("Thu Jan 1 00:00:00 PST 2009")
  end
  
  it "should return a valid last month range" do
    provider = OSX::TTTimeProvider.alloc.init
    provider.setNow( Time.parse("Fri Dec 12 12:10:03 PST 2008") )
    check rbTimeForNSDate(provider.lastMonthStartTime).should == Time.parse("Sat Nov 1 00:00:00 PDT 2008")
    check rbTimeForNSDate(provider.lastMonthEndTime).should ==   Time.parse("Mon Dec 1 00:00:00 PST 2008")
  end
  
end