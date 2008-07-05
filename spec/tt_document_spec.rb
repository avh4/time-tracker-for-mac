require File.dirname(__FILE__) + '/spec_helper'

require "TTDocument.bundle"
OSX::ns_import :TTDocument

describe OSX::TTDocument do
  
  it "should exist" do
    OSX::TTDocument
  end
  
  it "should have no projects when initialized" do
    doc = OSX::TTDocument.alloc.init
    doc.projects.size.should == 0
  end
  
  it "should allow projects to be added" do
    doc = OSX::TTDocument.alloc.init
    proj = mock("a project")
    doc.addProject(proj)
    doc.projects.size.should == 1
  end
  
  it "should allow projects to be removed" do
    doc = OSX::TTDocument.alloc.init
    proj = mock("a project")
    doc.addProject(proj)
    doc.removeProject(proj)
    doc.projects.size.should == 0
  end
end