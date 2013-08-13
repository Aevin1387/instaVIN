# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'instavin/version'

Gem::Specification.new do |spec|
  spec.name          = "instavin"
  spec.version       = InstaVIN::VERSION
  spec.authors       = ["Tony Coconate", "Cory Stephenson"]
  spec.email         = ["me@tonycoconate.com", "aevin@me.com"]
  spec.description   = %q{Provides a ruby interface for the instaVIN's API. Read more about it here: http://www.blackbookusa.com}
  spec.summary       = %q{A ruby interface for instaVIN Book's API}
  spec.homepage      = "http://github.com/Aevin1387/instaVIN"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "symboltable"
  spec.add_dependency "httparty"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock", '1.11' # Locked at 1.12.x to prevent VCR warnings
  spec.add_development_dependency "excon"
  spec.add_development_dependency "mocha"
end
