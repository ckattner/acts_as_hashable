# frozen_string_literal: true

require './lib/acts_as_hashable/version'

Gem::Specification.new do |s|
  s.name        = 'acts_as_hashable'
  s.version     = ActsAsHashable::VERSION
  s.summary     = 'Simple hash-based factory methods for objects.'

  s.description = <<-DESCRIPTION
    This is a small library that helps increase the pliability of object constructor signatures.
    Instead of instantiating via the constructor, this library can install helper factory
    class-level methods that you can use with hashes.
  DESCRIPTION

  s.authors     = ['Matthew Ruggio', 'Craig Kattner']
  s.bindir      = 'exe'
  s.email       = ['mruggio@bluemarblepayroll.com', '2313730+ckattner@users.noreply.github.com']
  s.executables = []
  s.files       = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.license     = 'MIT'
  s.metadata['rubygems_mfa_required'] = 'true'
  s.required_ruby_version = '>= 2.5'

  s.add_dependency('caution', '~>1')

  s.add_development_dependency('base64')
  s.add_development_dependency('guard-rspec', '~>4.7')
  s.add_development_dependency('pry')
  s.add_development_dependency('pry-byebug', '~> 3')
  s.add_development_dependency('rake', '~> 13.0')
  s.add_development_dependency('rspec')
  s.add_development_dependency('rspec_junit_formatter')
  s.add_development_dependency('rubocop', '~> 1.28.0')
  s.add_development_dependency('simplecov', '~>0.16.1')
  s.add_development_dependency('simplecov-console', '~>0.4.2')
end
