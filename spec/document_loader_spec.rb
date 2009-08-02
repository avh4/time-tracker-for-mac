require File.dirname(__FILE__) + '/spec_helper'

describe OSX::TTDocumentLoader do
  
  before(:each) do
    @loader = OSX::TTDocumentLoader.alloc.init
  end
  
  it "should load a V1 data model" do
    @doc = @loader.loadDocumentFromFile("Test Data/V1.archive")
    @doc.should_not be_nil
  end
  
end