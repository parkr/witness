require 'rubygems'
require 'rake'
require 'sinatra/activerecord/rake'
require './app'

preview_host = "127.0.0.1"
preview_port = 4000

desc "Preview the site in the web browser"
task :preview do
    puts "Starting Rack, serving to http://#{preview_host}:#{preview_port}"
    rackupPid = Process.spawn("rackup --host #{preview_host} --port #{preview_port}")

    trap("INT") {
      [rackupPid].each { |pid| Process.kill(9, pid) rescue Errno::ESRCH }
      exit 0
    }

    [rackupPid].each { |pid| Process.wait(pid) }
end

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -r ./lib/chat_log_server.rb"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :default => :spec
