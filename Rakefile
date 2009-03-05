require "rubygems"
require "rake"

Dir['tasks/**/*.rake'].each { |rake| load rake }

task :compile => "objc:compile"
task :compile_nib => "objc:compile_nib"

task :test => [:features, :spec]
task :spec => :compile

task :clean => "objc:clean"
