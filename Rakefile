require "bundler/gem_tasks"

task :default => :spec
task :test => :spec

namespace :cacert do
  desc "Update cacert.pem from curl.haxx.se"
  task :update do
    exec "curl http://curl.haxx.se/ca/cacert.pem > vendor/curl-cacert.pem"
  end
end

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
  warn "warn: RSpec tests not available. `gem install rspec` to enable them."
end

begin
  require 'yard'
  YARD::Rake::YardocTask.new do |t|
    t.options = ['--verbose']
  end
rescue LoadError
  warn "warn: YARD not available. `gem install yard` to enable."
end
