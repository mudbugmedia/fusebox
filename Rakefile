require 'rake'

task :default => :spec
task :test => :spec

namespace :cacert do
  desc "Update cacert.pem from curl.haxx.se"
  task :update do
    exec "curl -O http://curl.haxx.se/ca/cacert.pem > vendor/curl-cacert.pem"
  end
end

begin
  require 'spec'
  require 'spec/rake/spectask'

  desc "Run all specs"
  Spec::Rake::SpecTask.new('spec') do |t|
    t.spec_opts = ['--options', "spec/spec.opts"]
    t.spec_files = FileList['spec/*_spec.rb']
  end

  desc "Run integration (live api) spec"
  Spec::Rake::SpecTask.new('spec:integration') do |t|
    t.spec_opts = ['--options', "spec/spec.opts"]
    t.spec_files = FileList['spec/integration/*_spec.rb']
  end
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

def gemspec
  @gemspec ||= begin
    file = File.expand_path('../fusebox.gemspec', __FILE__)
    eval(File.read(file), binding, file)
  end
end

begin
  require 'rake/gempackagetask'
rescue LoadError
  task(:gem) { warn 'warn: rake not available. `gem install rake` to package gems' }
else
  Rake::GemPackageTask.new(gemspec) do |pkg|
    pkg.gem_spec = gemspec
  end
  task :gem => :gemspec
end

desc "validate the gemspec"
task :gemspec do
  gemspec.validate
end

desc "Build the gem"
task :gem => :gemspec do
  mkdir_p "pkg"
  sh "gem build fusebox.gemspec"
  mv "#{gemspec.full_name}.gem", "pkg"
end

task :release => :build do
  sh "gem push fusebox-#{Fusebox::VERSION}"
end
