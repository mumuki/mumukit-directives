# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mumukit/directives/version'

Gem::Specification.new do |spec|
  spec.name          = 'mumukit-directives'
  spec.version       = Mumukit::Directives::VERSION
  spec.authors       = ['Franco Leonardo Bulgarelli']
  spec.email         = ['franco@mumuki.org']

  spec.summary       = 'Interpolations, sections and flags pipelines for mumuki'
  spec.description   = 'A directives preprocessor for mumuki'
  spec.homepage      = 'https://github.com/mumuki/mumukit-directives'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*', 'bin/**/*']
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(lib bin)

  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'codeclimate-test-reporter'

  spec.required_ruby_version = '>= 3.0'

  spec.add_dependency 'mumukit-core', '~> 1.19'
end
