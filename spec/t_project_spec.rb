require File.dirname(__FILE__) + '/spec_helper'

require "Application.bundle"
OSX::ns_import :TProject

describe OSX::TProject do
  
  # We must define RubyCocoa objects for for certain mock objects
  # so that we can specify the return type for methods that do not
  # return objects
  class MockTask < OSX::NSObject
    objc_method :totalTime, "i@:"
  end
  
  
  it "should exist" do
    OSX::TProject
  end
  
  it "should initially have zero time" do
    proj = OSX::TProject.alloc.init
    proj.totalTime.should == 0
  end
  
  it "should sum the time of a single work period" do
    seconds = 10*60
    proj = OSX::TProject.alloc.init
    
    task = MockTask.new
    task.stub!(:totalTime).and_return(seconds)
    proj.addTask(task)
    
    proj.totalTime.should == seconds
  end
  
  it "should sum the time of multiple work periods" do
    seconds = [10*60, 55*60 + 5]
    proj = OSX::TProject.alloc.init
    
    tasks = [MockTask.new, MockTask.new]
    tasks[0].stub!(:totalTime).and_return(seconds[0])
    tasks[1].stub!(:totalTime).and_return(seconds[1])
    
    proj.addTask(tasks[0])
    proj.addTask(tasks[1])
    
    proj.totalTime.should == seconds[0] + seconds[1]
  end
  
  it "should sum the time correctly after the timer has updated a task" do
    seconds = 10*60
    seconds_later = 20*60
    proj = OSX::TProject.alloc.init
    
    task = MockTask.new
    task.stub!(:totalTime).and_return(seconds)
    proj.addTask(task)
    
    # Now the timer runs for a while...
    task.stub!(:totalTime).and_return(seconds_later)
    
    proj.totalTime.should == seconds_later
  end
  
  it "should return a project at a given index" do
    proj = OSX::TProject.alloc.init
    task1 = mock("Task 1")
    task2 = mock("Task 2")
    proj.addTask(task1)
    proj.addTask(task2)
    
    proj.objectInTasksAtIndex(0).should equal(task1)
    proj.objectInTasksAtIndex(1).should equal(task2)
  end
  
  it "should reorder projects" do
    proj = OSX::TProject.alloc.init
    task1 = mock("Task 1")
    task2 = mock("Task 2")
    proj.addTask(task1)
    proj.addTask(task2)
    
    proj.moveTask_toIndex(task2, 0)
    
    proj.objectInTasksAtIndex(0).should equal(task2)
    proj.objectInTasksAtIndex(1).should equal(task1)
  end  
  
end