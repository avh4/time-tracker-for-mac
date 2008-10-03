class MockDocument < OSX::NSObject
  objc_method :objectInProjectsAtIndex, "@@:i"
end

class MockNSTableView < OSX::NSObject
  objc_method :selectedRow, "i@:"
end

class MockProject < OSX::NSObject
end