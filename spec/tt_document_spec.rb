require File.dirname(__FILE__) + '/spec_helper'

require "Application.bundle"
OSX::ns_import :TTDocument

describe OSX::TTDocument do
  
  it "should exist" do
    OSX::TTDocument
  end
  
  it "should have no projects when initialized" do
    doc = OSX::TTDocument.alloc.init
    doc.projects.size.should equal(0)
  end
  
  it "should allow projects to be added" do
    doc = OSX::TTDocument.alloc.init
    proj = mock("a project")
    doc.addProject(proj)
    doc.projects.size.should equal(1)
  end
  
  it "should allow projects to be removed" do
    doc = OSX::TTDocument.alloc.init
    proj = mock("a project")
    doc.addProject(proj)
    doc.removeProject(proj)
    doc.projects.size.should equal(0)
  end
  
  it "should return a project at a given index" do
    doc = OSX::TTDocument.alloc.init
    proj1 = mock("Project 1")
    proj2 = mock("Project 2")
    doc.addProject(proj1)
    doc.addProject(proj2)
    
    doc.objectInProjectsAtIndex(0).should equal(proj1)
    doc.objectInProjectsAtIndex(1).should equal(proj2)
  end
end