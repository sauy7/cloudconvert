# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cloudconvert/version'

Gem::Specification.new do |spec|
  spec.name          = 'cloudconvert'
  spec.version       = Cloudconvert::VERSION
  spec.authors       = ['Pandurang Waghulde']
  spec.email         = ['pandurang.plw@gmail.com']
  spec.description   = 'Ruby wrapper for Cloud Convert'
  spec.summary       = 'Ruby wrapper for Cloud Convert'
  spec.homepage      = 'https://github.com/pandurang90/cloudconvert'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'

  spec.add_dependency 'faraday'
  spec.add_dependency 'json'
end
