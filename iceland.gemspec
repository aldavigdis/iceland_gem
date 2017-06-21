# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'iceland/version'

Gem::Specification.new do |spec|
  spec.name          = 'iceland'
  spec.version       = Iceland::VERSION
  spec.authors       = ['Stefan Vignir']
  spec.email         = ['stefanvignir@stefanvignir.is']

  spec.summary       = 'Handles the Icelandic "kennitala" identification '\
                       'scheme and postal codes'
  spec.description   = 'Adds the Kennitala class. Figures out dates and ages, '\
                       'and sanitizes "kennitala" objects and looks up '\
                       'Icelandic postal codes.'
  spec.homepage      = 'https://github.com/stefanvignir/iceland_gem'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`
                       .split("\x0")
                       .reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.6'
  spec.add_development_dependency 'rubocop', '~> 0.49'
  spec.add_development_dependency 'overcommit', '~> 0.39'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 1.0'
  spec.add_development_dependency 'yard', '~> 0.9'
  spec.add_development_dependency 'byebug', '~> 9.0'
end
