
task :build_release => [:spec, :features] do
  sh "xcodebuild -configuration Release -target 'Release Package' clean build"
end