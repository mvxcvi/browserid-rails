require 'browserid/rails/base'
require 'browserid/rails/helpers'
require 'browserid/rails/version'

module BrowserID
  module Rails
    # This class defines a Rails engine which extends the base controller with
    # the library methods. The presence of this engine also causes assets to
    # be included when the gem is added as a dependency.
    class Engine < ::Rails::Engine
      config.before_configuration do
        BrowserIDConfig = Struct.new :user_model, :email_field, :verifier, :audience

        config.browserid = BrowserIDConfig.new
        config.browserid.user_model = 'User'
        config.browserid.email_field = 'email'
        config.browserid.verifier = :persona
        config.browserid.audience = "http://localhost:3000"
      end

      initializer "browserid-rails.extend" do |app|
        ActionController::Base.send :include, BrowserID::Rails::Base
        ActionView::Base.send :include, BrowserID::Rails::Helpers
      end

      config.after_initialize do
        cfg = config.browserid

        # Replace type symbol with constructed verifier.
        if cfg.verifier == :persona
          cfg.verifier = BrowserID::Verifier::Persona.new(cfg.audience)
        elsif cfg.verifier == :local
          raise "Local BrowserID verification is not supported yet" # TODO
        elsif !cfg.verifier.respond_to?(:verify)
          raise "Unknown BrowserID verifier type #{cfg.verifier}"
        end
      end
    end
  end
end
