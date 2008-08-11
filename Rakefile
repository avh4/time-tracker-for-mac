require "rubygems"
require "rake"

Dir['tasks/**/*.rake'].each { |rake| load rake }

namespace :objc do
  desc "Compiles all Objective-C bundles for testing"
  task :compile
end

task :compile => "objc:compile"

task :test => :compile
task :spec => :compile

namespace :objc do
  task :compile => "build/bundles/Application.bundle"
  
  file "build/bundles/Application.bundle" do
    FileUtils.mkdir_p "build/bundles"
    FileUtils.rm Dir["build/bundles/Application.bundle"]
    sh "gcc -o build/bundles/Application.bundle -bundle -framework Cocoa -framework IOKit tasks/Application.m build/bundles/*.o"
  end
  
  # look for Classes/*.m files containing a line "void Init_ClassName"
  # These are the primary classes for bundles; make a bundle for each
  model_file_paths = `find ./*.m -exec grep -l "^void Init_" {} \\;`.split("\n")
  model_file_paths.push "./MainController.m"
  
  model_file_paths.each do |path|
    path =~ /\.\/(.*)\.m/
    model_name = $1
    
    file "build/bundles/Application.bundle" => "build/bundles/#{model_name}.o"
    
    file "build/bundles/#{model_name}.o" => ["./#{model_name}.m", "./#{model_name}.h"] do |t|
      FileUtils.mkdir_p "build/bundles"
      sh "gcc -o build/bundles/#{model_name}.o -c ./#{model_name}.m"
    end

  end

end

