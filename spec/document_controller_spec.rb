require File.dirname(__FILE__) + '/spec_helper'

describe OSX::TTDocumentController do
  
  it "should load a V1 data model" do
    @doc = OSX::TTDocumentController.loadDocumentFromFile("Test Data/V1.archive")
    @doc.should_not be_nil
  end
  
end