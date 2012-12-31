#!/usr/bin/env rake

begin
  require 'bundler/setup'
  Bundler::GemHelper.install_tasks
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new :spec do |config|
  # ...
end

task :default => :spec
