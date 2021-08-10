# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

task default: %i[rubocop spec]

spec    = Gem::Specification.load('acts_as_hashable.gemspec')
name    = spec.name
version = spec.version
host    = 'https://gems.bluemarblepayroll.com/private'
key     = 'bluemarblepayroll_api_key'

Rake::Task['release'].clear

desc "Publish #{version} to Blue Marble's private gem server"
task release: :build do
  sh "gem push --host #{host} pkg/#{name}-#{version}.gem --key #{key}"
end
