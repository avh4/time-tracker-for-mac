require File.dirname(__FILE__) + '/spec_helper'

describe OSX::TTApplicationState do
  before(:each) do
    @as = OSX::TTApplicationState.alloc.init
  end

end