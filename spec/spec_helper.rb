require 'spec'
require "osx/cocoa"

$:.unshift File.dirname(__FILE__) + "/../build/bundles"

require "Application.bundle"

require File.dirname(__FILE__) + '/mocks'

def rbTimeForNSDate(d)
  return Time.parse("" + d.description)
end

def loadNibWithOwner(file, owner)
  file = "build/nibs/#{file}"
  nib = OSX::NSNib.alloc.initWithContentsOfURL(OSX::NSURL.URLWithString(file))
  fail "Could not load the NIB file '#{file}'" if nib == nil
  bool = nib.instantiateNibWithOwner_topLevelObjects(owner, nil)
  fail "#{file}: NIB file failed to instantiate" if !bool
end

# This method is used to prevent warnings on lines like this
#    some_number.should == 7
# Instead, use
#    check some_number.should == 7
#
# See http://rubyforge.org/tracker/?func=detail&atid=3149&aid=7101&group_id=797
def check(*args)
end