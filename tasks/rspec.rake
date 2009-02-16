require "spec/rake/spectask"

task :default => :spec

task :spec => :compile
task :spec => :compile_nib
  
Spec::Rake::SpecTask.new do |t|
end