require "spec"
require "osx/cocoa"
require "time"
require "duration"

$:.unshift File.dirname(__FILE__) + "/../../build/bundles"
require "Application.bundle"

Given /I have recorded my data in Time Tracker/ do
  @controller = OSX::MainController.alloc.init;
  @doc = OSX::TTDocument.alloc.init
  @today = Time.parse("2008-09-01")
  
  @p1 = project = OSX::TProject.alloc.initWithName("Project 1")
    @t11 = task = OSX::TTask.alloc.initWithName("Task 1.1")
      task.addWorkPeriod( OSX::TWorkPeriod.alloc.initWithStartTime_endTime(Time.parse("2008-08-31 10:00:00"), Time.parse("2008-08-31 10:30:00")) )
      task.addWorkPeriod( OSX::TWorkPeriod.alloc.initWithStartTime_endTime(Time.parse("2008-08-31 23:00:00"), Time.parse("2008-09-01 01:00:00")) )
      task.addWorkPeriod( OSX::TWorkPeriod.alloc.initWithStartTime_endTime(Time.parse("2008-09-01 10:00:00"), Time.parse("2008-09-01 10:45:00")) )
    project.addTask(task)    
  @doc.addProject(project)
  @controller.setDocument(@doc)
end

When /I set the filter to "Today"/ do
  @controller.setFilterStartTime_endTime(@today, @today + 1.days)
end

Then /I will see today.s totals for all projects/ do
  @controller.totalTimeForProject(@p1).should == 1.hour + 45.minutes
end

Then /I will see today.s totals for all tasks/ do
  @controller.totalTimeForTask(@t11).should == 1.hour + 45.minutes
end

Then /I will only see today.s work periods/ do
  @controller.countOfWorkPeriodsForTask(@t11).should == 2
end
