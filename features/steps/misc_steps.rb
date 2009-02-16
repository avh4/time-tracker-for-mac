$:.unshift File.dirname(__FILE__) + "/../../build/bundles"
require "Application.bundle"

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
  wp = OSX::TWorkPeriod.alloc.init
  time_start = OSX::NSDate.alloc.init
  time_end = OSX::NSDate.alloc.initWithTimeInterval_sinceDate(min.to_i*60, time_start)
  wp.setStartTime(time_start)
  wp.setEndTime(time_end)
  
  task = OSX::TTask.alloc.init
  task.addWorkPeriod(wp)
  
  @sel_proj.addTask(task)
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