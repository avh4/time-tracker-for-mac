require "spec/rake/spectask"
gem 'ci_reporter'
require 'ci/reporter/rake/rspec'

task :default => :spec

task :spec => :compile
task :spec => :compile_nib
task :spec => 'ci:setup:rspec'
  
Spec::Rake::SpecTask.new do |t|
end

rule(/spec:.+/) do |t|
  name = t.name.gsub("spec:","")

  path = File.join( File.dirname(File.dirname(__FILE__)),'spec','%s_spec.rb'%name )

  if File.exist? path
    Spec::Rake::SpecTask.new(name) do |t|
      t.spec_files = [path]
    end

    puts "\nRunning spec/%s_spec.rb"%[name]

    Rake::Task[name].invoke
  else
    puts "File does not exist: %s"%path
  end

end