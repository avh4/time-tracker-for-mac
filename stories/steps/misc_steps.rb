require "TProject.bundle"
OSX::ns_import :TProject
require "TTask.bundle"
OSX::ns_import :TTask
require "TWorkPeriod.bundle"
OSX::ns_import :TWorkPeriod

steps_for(:misc) do
  
  Given "a new project" do
    @proj = OSX::TProject.alloc.init
  end
  
  When "the project is selected" do
  end
  
  When "the timer is run for $min minutes" do |min|
    wp = OSX::TWorkPeriod.alloc.init
    time_start = OSX::NSDate.alloc.init
    time_end = OSX::NSDate.alloc.initWithTimeInterval_sinceDate(min.to_i*60, time_start)
    wp.setStartTime(time_start)
    wp.setEndTime(time_end)
    
    task = OSX::TTask.alloc.init
    task.addWorkPeriod(wp)
    
    @proj.addTask(task)
  end
  
  Then "the project's total time should be $min minutes" do |min|
    @proj.tasks[0].totalTime.should == min.to_i * 60
    @proj.totalTime.should == min.to_i * 60
  end
  
end