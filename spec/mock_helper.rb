require "Application.bundle"

# Here we are creating a mock object that Obj-C thinks is a subclass
# of TProject, but which ignores the Obj-C implementation of TProject.
# This trick is used to allow rmock to intercept a method that would normally
# be handled by the obj-c class without rmock even knowing about it:
#
#   def the_method_to_hide
#     return super.super.the_method_to_hide
#   end
#
class MockProject < OSX::TProject
  def name
    return super.super.name
  end
  def totalTime
    return super.super.totalTime
  end
end

# "MockTask" is already defined in t_project_spec.rb
class MockTask_ < OSX::TTask
  def name
    return super.super.name
  end
  def totalTime
    return super.super.totalTime
  end
end

# We must define RubyCocoa objects for for certain mock objects
# so that we can specify the return type for methods that do not
# return objects
class MockWorkPeriod < OSX::NSObject
  objc_method :totalTime, "i@:"
end

# We must define RubyCocoa objects for for certain mock objects
# so that we can specify the return type for methods that do not
# return objects
class MockTask < OSX::NSObject
  objc_method :totalTime, "i@:"
end
