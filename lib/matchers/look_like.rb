class LookLike
  def initialize(description)
    @description = description
  end
  def matches?(object)
    @object = object
    @error = OSX::GTMRenderer.isImageOfObject_matches(@object, @description)
    return @error == nil
  end
  def description
    "look like"
  end
  def failure_message
    "expected #{@object} to look like '#{@description}': #{@error}"
  end
  def negative_failure_message
    "expected #{@object} not to look like '#{@description}"
  end
end

def look_like(description)
  LookLike.new(description)
end
