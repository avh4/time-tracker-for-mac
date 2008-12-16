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
end

class MockProject < OSX::NSObject
end

class MockTask < OSX::NSObject
end

# We must define RubyCocoa objects for for certain mock objects
# so that we can specify the return type for methods that do not
# return objects
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