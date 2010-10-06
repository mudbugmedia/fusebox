# -*- encoding: utf-8 -*-
require File.expand_path('../lib/fusebox/version', __FILE__)
 
Gem::Specification.new do |s|
  s.name        = "fusebox"
  s.version     = Fusebox::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Gabe Martin-Dempesy"]
  s.email       = ["gabe@mudbugmedia.com.com"]
  s.homepage    = "http://github.com/mudbugmedia/fusebox"
  s.summary     = "FuseMail API client library"
  s.description = "FuseMail API client library"
 
  s.required_rubygems_version = ">= 1.3.6"
 
 
  s.add_dependency('activesupport', '>= 2.0')
  s.add_development_dependency "rspec"
 
  s.files        = Dir.glob("lib/**/*") + Dir.glob("spec/*") + %w(LICENSE README.md)
  s.require_path = 'lib'
end
