require 'browserid/rails/version'
require 'browserid/rails/base'
require 'browserid/verifier/persona'

module BrowserID
  module Rails
    # This empty class signals to Rails to treat the gem as an engine, so that
    # assets will be included when the gem is added as a dependency.
    class Engine < ::Rails::Engine
    end
  end
end
