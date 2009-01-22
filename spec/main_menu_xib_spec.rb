require File.dirname(__FILE__) + '/spec_helper'

describe "MainMenu.xib" do

  before(:each) do
    @mockOwner = MockApplication.new
    loadNibWithOwner("MainMenu.nib", @mockOwner)
  end

  it "should set the application delegate" do
    @mockOwner.delegate.should_not be_nil
  end

end