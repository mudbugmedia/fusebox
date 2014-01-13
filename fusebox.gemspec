# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fusebox/version'

Gem::Specification.new do |spec|
  spec.name          = "fusebox"
  spec.version       = Fusebox::VERSION
  spec.authors       = ["Gabe Martin-Dempesy"]
  spec.email         = ["gabe@mudbugmedia.com"]
  spec.description   = "FuseMail API client library and CLI"
  spec.summary       = "FuseMail API client library and CLI"
  spec.homepage      = "http://github.com/mudbugmedia/fusebox"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 2.0"
  spec.add_dependency "thor", "~> 0.14"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "yard"
end
