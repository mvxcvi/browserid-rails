require 'browserid/rails/version'
require 'browserid/rails/base'
require 'browserid/rails/helpers'
require 'browserid/verifier/persona'

module BrowserID
  module Rails
    # This class defines a Rails engine which extends the base controller with
    # the library methods. The presence of this engine also causes assets to
    # be included when the gem is added as a dependency.
    class Engine < ::Rails::Engine
      initializer "browserid-rails" do |app|
        ActionController::Base.send :include, BrowserID::Rails::Base
        ActionView::Base.send :include, BrowserID::Rails::Helpers
      end
    end
  end
end
