require 'browserid/verifier/persona'

module BrowserID
  module Rails
    # Public: Base module for inclusion into a controller. This module includes
    # methods for dealing with BrowserID user authentication.
    module Base

      ##### INTERNAL METHODS #####

      # Internal: Modifies the controller this module is included in to provide
      # authentication-related helper methods
      #
      # base - The Class this module is being included in.
      def self.included(base)
        base.send :helper_method, :browserid_email, :current_user, :authenticated?
      end

      # Internal: Gets the application configuration for this gem.
      #
      # Returns the app config structure.
      def browserid_config
        ::Rails.application.config.browserid
      end



      ##### AUTHENTICATION METHODS #####

      # Public: Verifies the given BrowserID assertion. If successful, this
      # sets the authenticated email as the logged-in user.
      #
      # Returns true on success or false on failure.
      def verify_browserid(assertion)
        email, issuer = browserid_config.verifier.verify(assertion)
        logger.info "Verified BrowserID assertion for #{email} issued by #{issuer}"
        login_browserid email
        true
      rescue StandardError => e # TODO: distinguish verification failures from invalid assertions
        logger.info "Failed to verify BrowserID assertion: #{e.message}"
        false
      end

      # Public: Sets the given email address as the currently-authenticated user.
      # The address is saved in the client's session.
      #
      # email - The String email address to consider authenticated.
      def login_browserid(email)
        session[:browserid_email] = email
      end

      # Public: Clears the saved email address for the currently-authenticated
      # user. It is important to note that this does not remove the BrowserID
      # assertion in the client's browser.
      def logout_browserid
        session[:browserid_email] = nil
      end



      ##### HELPER METHODS #####

      # Public: Gets the email address of the currently-authenticated user.
      #
      # Returns the authenticated email address String.
      def browserid_email
        session[:browserid_email]
      end

      # Public: Retrieves the user for the authenticated email address. This
      # method uses the `browserid.user_model` and `browserid.email_field`
      # config settings, which default to `User` and `email`.
      #
      # Returns the current authenticated user, or nil if no user exists.
      def current_user
        if browserid_email.nil?
          nil
        elsif @current_user
          @current_user
        else
          config = browserid_config
          user_model = config.user_model.constantize
          find_method = "find_by_#{config.email_field}".intern

          @current_user = user_model.send find_method, browserid_email
        end
      end

      # Public: Determines whether the current client is authenticated as a
      # registered User.
      #
      # Returns true if the client is authenticated and registered.
      def authenticated?
        !current_user.nil?
      end
    end
  end
end
