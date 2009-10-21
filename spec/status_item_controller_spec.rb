require File.dirname(__FILE__) + '/spec_helper'

describe OSX::TTStatusItemController do
  
  before(:each) do
    @appState = MockApplicationState.new
    @mockResources = mock("Resources")
    @mockResources.stub!(:playItemImage).and_return("Play Item Image")
    @mockResources.stub!(:stopItemImage).and_return("Stop Item Image")
    @mockStatusItem = mock("Status Item")
    @mockStatusItem.stub!(:setImage)
    @mockStatusItem.stub!(:setTitle)
    @sic = OSX::TTStatusItemController.alloc.initWithStatusItem_resources_applicationState @mockStatusItem, @mockResources, @appState
  end
  
  it "should be a start button when the timer is stopped" do
    @appState.stub!(:isTimerRunning).and_return(false)
    @mockStatusItem.should_receive(:setImage).with("Play Item Image")
    @sic.update
  end
  
  it "should be a stop button when the timer is running" do
    @appState.stub!(:isTimerRunning).and_return(true)
    @mockStatusItem.should_receive(:setImage).with("Stop Item Image")
    @sic.update
  end

end