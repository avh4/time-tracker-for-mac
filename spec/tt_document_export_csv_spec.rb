require File.dirname(__FILE__) + '/spec_helper'

require "Application.bundle"
OSX::ns_import :TTDocument

describe OSX::TTDocument do
  
  it "should export an empty CSV file" do
    doc = OSX::TTDocument.alloc.init
    
    data, error = doc.dataOfType_error("CSV")
    error.should be_nil
    
    data.should equal(%Q{
    }.gsub!(/^\s*/, ''))
  end
  
  it "should export a simple CSV file" do
    doc = OSX::TTDocument.alloc.init
    
    pr1 = mock("Project 1")
    pr2 = mock("Project 2")
    
    doc.setProjects( [pr1, pr2] )
    
    data, error = doc.dataOfType_error("CSV")
    error.should be_nil
    
    data.should equal(%Q{
      Project 1,Task 1.1,2008-01-01,10:20:00,2008-01-01,10:30:00,00:10:00
      Project 1,Task 1.1,2008-01-01,10:35:00,2008-01-01,10:40:10,00:05:10
      Project 1,Task 1.2,2008-01-03,10:35:00,2008-01-03,10:40:10,00:05:10
      Project 2,Task 2.1,2008-02-04,10:35:00,2008-02-04,10:40:10,00:05:10
    }.gsub!(/^\s*/, ''))
  end

end