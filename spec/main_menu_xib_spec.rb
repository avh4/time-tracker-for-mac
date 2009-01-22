require File.dirname(__FILE__) + '/spec_helper'

describe "MainMenu.xib" do

  before(:each) do
    @mockOwner = MockApplication.new
    loadNibWithOwner("MainMenu.nib", @mockOwner)
    @mc = @mockOwner.delegate
  end

  it "should set the application delegate" do
    @mockOwner.delegate.should_not be_nil
  end

  it "should set the main window" do
    @mc.mainWindow.should_not be_nil
  end

  def indexActions(view)
    actions = {}
    search = [view]
    while (!search.empty?)
      item = search.pop
      if (item.respondsToSelector(:target))
        # puts "#{item}: #{item.target} #{item.action}"
        actions["#{item.target} #{item.action}"] = item
      end
      if (item.respondsToSelector(:subviews))
        search += item.subviews
      end
      if (item.respondsToSelector(:itemArray))
        search += item.itemArray
      end
    end
    actions
  end

  ["filterToToday", "filterToYesterday", "filterToThisWeek", "filterToLastWeek",
    "filterToWeekBeforeLast", "filterToThisMonth", "filterToLastMonth"].each do |f|

    it "should have a widget who's action is #{f}" do
      actions = indexActions(@mc.mainWindow.contentView)
      actions.should have_key("#{@mc} #{f}:")
    end

  end

end