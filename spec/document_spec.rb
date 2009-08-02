require File.dirname(__FILE__) + '/spec_helper'

describe OSX::TTDocumentV1 do
  
  it "should exist" do
    OSX::TTDocumentV1
  end
  
  it "should have no projects when initialized" do
    doc = OSX::TTDocumentV1.alloc.init
    doc.projects.should_not be_nil
    doc.projects.size.should equal(0)
  end
  
  it "should allow projects to be added" do
    doc = OSX::TTDocumentV1.alloc.init
    proj = mock("a project")
    doc.addProject(proj)
    doc.projects.size.should equal(1)
  end
  
  it "should allow projects to be removed" do
    doc = OSX::TTDocumentV1.alloc.init
    proj = mock("a project")
    doc.addProject(proj)
    doc.removeProject(proj)
    doc.projects.size.should equal(0)
  end
  
  it "should return a project at a given index" do
    doc = OSX::TTDocumentV1.alloc.init
    proj1 = mock("Project 1")
    proj2 = mock("Project 2")
    doc.addProject(proj1)
    doc.addProject(proj2)
    
    doc.objectInProjectsAtIndex(0).should equal(proj1)
    doc.objectInProjectsAtIndex(1).should equal(proj2)
  end
  
  it "should reorder projects" do
    doc = OSX::TTDocumentV1.alloc.init
    proj1 = mock("Project 1")
    proj2 = mock("Project 2")
    doc.addProject(proj1)
    doc.addProject(proj2)
    
    doc.moveProject_toIndex(proj2, 0)
    
    doc.objectInProjectsAtIndex(0).should equal(proj2)
    doc.objectInProjectsAtIndex(1).should equal(proj1)
  end
    
end