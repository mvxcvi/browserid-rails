# This file initializes the rspec test suite.

# Default rails environment to 'test'.
ENV["RAILS_ENV"] ||= 'test'

# Determine engine root.
ENGINE_ROOT = File.expand_path("../..", __FILE__)

# Initialize simplecov to establish code coverage.
require 'simplecov'
SimpleCov.start do
  coverage_dir 'doc/coverage'

  add_filter '/spec/'

  # filter out files less than 5 lines long
  #add_filter { |file| file.lines.count < 5 }

  add_group "Library",   'lib'
end

# Load rails environment and rspec framework.
require File.expand_path("../dummy/config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(ENGINE_ROOT, "spec/support/**/*.rb")].each {|f| require f}

# Configure rspec.
RSpec.configure do |config|
  # Mock Framework
  # config.mock_with :mocha|:flexmock|:rr

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  config.order = "random"
end

# Load gem code.
require 'browserid-rails'
