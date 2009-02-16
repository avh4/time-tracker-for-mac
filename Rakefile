require "rubygems"
require "rake"

Dir['tasks/**/*.rake'].each { |rake| load rake }

namespace :objc do
  desc "Compiles all Objective-C bundles for testing"
  task :compile
end

task :compile => "objc:compile"
task :compile_nib => "objc:compile_nib"

task :test => [:features, :spec]
task :spec => :compile

task :clean => "objc:clean"

namespace :objc do
  task :clean do
    FileUtils.rm_r Dir["build/bundles"]
    FileUtils.rm_r Dir["build/nibs"]
  end
  
  task :compile => "build/bundles/Application.bundle"
  
  file "build/bundles/Application.bundle" do
    FileUtils.mkdir_p "build/bundles"
    FileUtils.rm Dir["build/bundles/Application.bundle"]
    sh "gcc -o build/bundles/Application.bundle -bundle -framework Cocoa -framework IOKit tasks/Application.m build/bundles/*.o"
  end
  
  # look for Classes/*.m files containing a line "void Init_ClassName"
  # These are the primary classes for bundles; make a bundle for each
  model_file_paths = `find ./*.m`.split("\n")
  model_file_paths.delete "./main.m"
  
  model_file_paths.each do |path|
    path =~ /\.\/(.*)\.m/
    model_name = $1
    
    file "build/bundles/Application.bundle" => "build/bundles/#{model_name}.o"
    
    file "build/bundles/#{model_name}.o" => ["./#{model_name}.m", "./#{model_name}.h"] do |t|
      FileUtils.mkdir_p "build/bundles"
      sh "gcc -o build/bundles/#{model_name}.o -c ./#{model_name}.m"
    end

  end

  nib_files = ["MainMenu"]
  nib_files.each do |nib_name|
    nib = "build/nibs/#{nib_name}.nib"
    xib = "English.lproj/#{nib_name}.xib"

    task :compile_nib => nib

    file nib => xib do
      FileUtils.mkdir_p "build/nibs"
      puts "Compiling #{xib} to #{nib}"
      sh "ibtool --errors --warnings --notices --output-format human-readable-text --compile #{nib} #{xib}"
    end

  end

end

