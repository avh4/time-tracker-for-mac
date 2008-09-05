require "spec"
require "osx/cocoa"
require "time"

$:.unshift File.dirname(__FILE__) + "/../../build/bundles"
require "Application.bundle"

Given /I have recorded my data in Time Tracker/ do
  @doc = OSX::TTDocument.alloc.init
  @today = Time.parse("2008-09-01")
  
  project = OSX::TProject.alloc.initWithName("Project 1")
    task = OSX::TTask.alloc.initWithName("Task 1.1")
      task.addWorkPeriod( OSX::TWorkPeriod.alloc.initWithStartTime_endTime(Time.parse("2008-08-31 10:00:00"), Time.parse("2008-08-31 10:30:00")) )
      task.addWorkPeriod( OSX::TWorkPeriod.alloc.initWithStartTime_endTime(Time.parse("2008-08-31 23:00:00"), Time.parse("2008-09-01 01:00:00")) )
      task.addWorkPeriod( OSX::TWorkPeriod.alloc.initWithStartTime_endTime(Time.parse("2008-09-01 10:00:00"), Time.parse("2008-09-01 10:45:00")) )
    project.addTask(task)    
  @doc.addProject(project)
end