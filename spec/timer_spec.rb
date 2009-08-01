require File.dirname(__FILE__) + '/spec_helper'

describe OSX::TTTimer do
  
  describe "initial state" do
    before(:each) do
      @t = OSX::TTTimer.alloc.initWithDelegate(nil)
    end
    
    it "should not be running" do
      @t.isRunning.should == 0
    end
  end
  
  describe "when started" do
    before(:each) do
      @t = OSX::TTTimer.alloc.init
      @t.start
    end
    
    it "should be running" do
      @t.isRunning.should == 1
    end
  end
  
  describe "when started and stopped shortly after" do
    before(:each) do
      @t = OSX::TTTimer.alloc.init
      @t.start
      @t.stop
    end
    
    it "should not be running" do
      @t.isRunning.should == 0
    end
  end

end