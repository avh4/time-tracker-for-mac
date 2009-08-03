require File.dirname(__FILE__) + '/spec_helper'

describe OSX::TTStatusItemController do
  
  def sic_looks_like(what)
    if @sic.statusItem.view != nil
      @sic.statusItem.view.should look_like(what)
    else
      @sic.image.should_not be_nil
      size = @sic.image.size
      img = OSX::NSImageView.alloc.initWithFrame(OSX::NSRect.new(0, 0, size.width, size.height))
      img.setImage(@sic.image)
      img.should look_like(what)
    end
  end
  
  before(:each) do
    @appState = MockApplicationState.new
    @sic = OSX::TTStatusItemController.alloc.init
    @sic.applicationState = @appState
  end
  
  it "should have a status item" do
    @sic.statusItem.should_not be_nil
  end
  
  describe "when the timer is stopped" do
    before(:each) do
      @appState.stub!(:isTimerRunning).and_return(false)
      @sic.update
    end
    it "should be a start button" do
      sic_looks_like("status item start button")
    end
  end
  
  describe "when the timer is running" do
    before(:each) do
      @appState.stub!(:isTimerRunning).and_return(true)
      @sic.update
    end
    it "should be a stop button" do
      sic_looks_like("status item stop button")
    end
  end

end