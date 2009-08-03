# We must define RubyCocoa objects for for certain mock objects
# so that we can specify the return type for methods that do not
# return objects

class MockDocument < OSX::NSObject
  objc_method :objectInProjectsAtIndex, "@@:i"
end

class MockNSArray < OSX::NSObject
  objc_method :objectAtIndex, "@@:i"
end

class MockNSWindow < OSX::NSObject
end

class MockNSTableView < OSX::NSObject
  objc_method :selectedRow, "i@:"
end

class MockDocumentController < OSX::NSObject
  objc_method :workPeriodAtIndex, "v@:i"
  objc_method :setFilterStartTime_endTime, "v@:@@"
end

class MockProject < OSX::NSObject
end

class MockTask < OSX::NSObject
  objc_method :totalTime, "d@:"
  objc_method :totalTimeInRangeFrom_to, "d@:@@"
end

class MockWorkPeriod < OSX::NSObject
  objc_method :totalTime, "d@:"
  objc_method :compare, "i@:@"
  objc_method :totalTimeInRangeFrom_to, "d@:@@"
  objc_method :startTime, "@@:"
  objc_method :endTime, "@@:"
end

class MockUserInterfaceItem < OSX::NSObject
  #objc_method :action, "s@:"
end

class MockDatePicker < OSX::NSObject
  objc_method :setDateValue, "v@:@"
  objc_method :setEnabled, "v@:B"
end

class MockApplicationState < OSX::NSObject
  objc_method :isTimerRunning, "B@:"
end

# The following mocks are used for unarchiving NIB files.
# See main_menu_xib_spec.rb
class MockApplication < OSX::NSObject
  attr_accessor :delegate
  def initialize
    self.stub!(:hide)
    self.stub!(:hideOtherApplications)
    self.stub!(:orderFrontStandardAboutPanel)
    self.stub!(:unhideAllApplications)
    self.stub!(:terminate)
  end
end

class OSX::SUUpdater < OSX::NSObject
  def initialize
    self.stub!(:checkForUpdates)
  end
end
