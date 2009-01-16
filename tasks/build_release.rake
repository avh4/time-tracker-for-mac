require 'yaml'
require 'text/format'

task :build_release => [:spec, :features, :changelog] do
  sh "xcodebuild -configuration Release -target 'Release Package' clean build"
end

task :changelog => ['ChangeLog.txt']
task :clean do
  sh "rm -vf ChangeLog.txt"
end

file 'ChangeLog.txt' => 'ChangeLog.yml' do |t|
  puts "Generating '#{t.name}' from '#{t.prerequisites}'"

  # Load the yml file
  yaml = YAML.load_file(t.prerequisites.first)
  
  # Write the changelog file
  fmt_bullets = Text::Format.new
  fmt_bullets.first_indent = 0
  fmt_bullets.body_indent = 4
  fmt_notes = Text::Format.new
  fmt_notes.first_indent = 0
  
  File.open(t.name, 'w') do |txt|
    yaml.each do |release|
      txt.puts "=== #{release['version']} ===  #{release['date']}"
      txt.puts fmt_notes.format(release['notes'])  if release['notes']
      txt.puts
      release['changes'].each do |change|
        txt.puts "  * " + fmt_bullets.format(change)
      end
      txt.puts
    end
  end

end