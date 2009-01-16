require 'yaml'
require 'text/format'
require 'builder'

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

### Appcast files


yaml = YAML.load_file('ChangeLog.yml')
yaml.each do |release|
  version = release['version']
  task :appcast => "appcast/timetracker-#{version}.html"
  task :clean do
    sh "rm -vf appcast/timetracker-#{version}.html"
  end
  file "appcast/timetracker-#{version}.html" => 'ChangeLog.yml' do |t|
    puts "Generating '#{t.name}'"
    file = File.open(t.name, 'w')
    html = Builder::XmlMarkup.new(:target => file, :indent => 2)
    
    start_release = yaml.index(release)
    end_release = yaml.length - 1
    html.html {
      html.head {
        html.meta('http-equiv' => "content-type", :content => "text/html;charset=utf-8")
        html.title("Time Tracker #{version}")
        html.meta(:name => "robots", :content => "anchors")
        html.link(:href => "timetracker.css", :type => "text/css", :rel => "stylesheet", :media => "all")
      }
      html.body {
        yaml[start_release..end_release].each do |release|
          html.table(:class => "dots", :width => "100%", :border => "0", :cellspacing => "0", :cellpadding => "0") {
            html.tr {
              html.td(:class => "blue", :colspan => "2") {
                html.h3("Changes in Time Tracker #{release['version']}")
              }
            }
            html.tr {
              html.td(:valign => "top", :width => "64") {
                html.img(:src => "logo.png", :alt => "Time Tracker logo", :width => "64", :border => "0")
              }
              html.td(:valign => "top") {
                html.ul {
                  release['changes'].each do |change|
                    html.li(change)
                  end
                }
              }
            }
            html.br
          }
        end 		
      }
    }
  end
end
