require "spec"
require "osx/cocoa"
require "time"
require "duration"

class FakeTimer
  
end

$:.unshift File.dirname(__FILE__) + "/../../build/bundles"
require "Application.bundle"

def advance_time(min)
  wp = OSX::TWorkPeriod.alloc.init
  time_start = OSX::NSDate.alloc.init
  time_end = OSX::NSDate.alloc.initWithTimeInterval_sinceDate(min.to_i*60, time_start)
  wp.setStartTime(time_start)
  wp.setEndTime(time_end)
  
  task = OSX::TTask.alloc.init
  task.addWorkPeriod(wp)
  
  @sel_proj.addTask(task)
end

Given "a new document" do
  @doc = OSX::TTDocumentV1.alloc.init
end

Given "a new project" do
  @proj = OSX::TProject.alloc.init
end

When "a new project is created called \"$name\"" do |name|
  proj = OSX::TProject.alloc.init
  proj.setName(name)
  @doc.addProject(proj)
end

When "the project is selected" do
  @sel_proj = @proj
end

When "project $n is selected" do |n|
  @sel_proj = @doc.projects[n.to_i-1]
end

When "the timer is run for $min minutes" do |min|
  advance_time(min)
end

Then "the project's total time should be $min minutes" do |min|
  @proj.tasks[0].totalTime.should == min.to_i * 60
  @proj.totalTime.should == min.to_i * 60
end

Then "the total time for project $n should be $min minutes" do |n, min|
  @doc.projects[n.to_i-1].totalTime.should == min.to_i * 60
end

Then "the number of projects in the document should be $n" do |n|
  @doc.projects.size.should == n.to_i
end




Given /I have recorded my data in Time Tracker/ do
  @controller = OSX::MainController.alloc.init;
  @doc = OSX::TTDocumentV1.alloc.init
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
  @controller = OSX::MainController.alloc.init
  @doc = @controller.document
end

Given /^Time Tracker is newly installed$/ do
  @controller = OSX::MainController.alloc.init
  @doc = @controller.document
  @timer = FakeTimer.new
  @controller.timer = @timer
end


When /I set the filter to "Today"/ do
  @controller.setFilterStartTime_endTime(@today, @today + 1.days)
end

When /I start the timer/ do
  @controller.startTimer
end

When /^then I wait for 10 minutes to pass$/ do
  advance_time(10)
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
