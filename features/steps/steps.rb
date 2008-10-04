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

Given /I have started Time Tracker for the first time/ do
  @controller = OSX::MainController.alloc.init;
  @doc = @controller.document
end

When /I set the filter to "Today"/ do
  @controller.setFilterStartTime_endTime(@today, @today + 1.days)
end

When /I start the timer/ do
  @controller.startTimer
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

Then /the document should have one project/ do
  @doc.projects.count.should == 1
end

Then /the first project should have one task/ do
  @doc.projects[0].tasks.count.should == 1
end

Then /the active task should be the first task of the first project/ do
  @controller.activeTask.should == @doc.projects[0].tasks[0]
end

Then /the selected task should be the first task of the first project/ do
  @controller.selectedTask.should == @doc.projects[0].tasks[0]
end
