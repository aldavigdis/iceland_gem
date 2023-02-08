# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'iceland'

Gem::Specification.new do |spec|
  spec.name          = 'iceland'
  spec.version       = Iceland::VERSION
  spec.authors       = ['Alda Vigdís']
  spec.email         = ['aldavigdis@aldavigdis.is']

  spec.summary       = 'A meta package of the Postnumer and Kennitala gems.'

  spec.homepage      = 'https://github.com/stefanvignir/iceland_gem'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.6.0'

  spec.files         = `git ls-files -z`
                       .split("\x0")
                       .reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.3.7'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rubocop', '~> 1.44'

  spec.add_runtime_dependency  'kennitala', '~> 0.1'
  spec.add_runtime_dependency  'postnumer', '~> 0.2'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
