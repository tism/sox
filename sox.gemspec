# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'sox/version'

Gem::Specification.new do |s|
  s.name        = "sox"
  s.version     = Sox::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Lucas Maxwell"]
  s.email       = ["lucas@thecowsays.mu"]
  s.homepage    = "http://github.com/tism/sox"
  s.summary     = "FFI binding for the sox library"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "bundler"

  s.add_dependency "ffi"
  s.add_development_dependency "rspec"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
end
