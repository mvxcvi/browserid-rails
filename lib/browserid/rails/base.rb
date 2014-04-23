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
        base.send :helper_method, :browserid_config, :browserid_email, :browserid_current_user, :browserid_authenticated?
      end

      # Internal: Gets the application configuration for this gem.
      #
      # Returns the app config structure.
      def browserid_config
        ::Rails.application.config.browserid
      end



      ##### HELPER METHODS #####

      # Public: Gets the email address of the currently-authenticated user.
      #
      # Returns the authenticated email address String.
      def browserid_email
        session[browserid_config.session_variable]
      end

      # Public: Retrieves the user for the authenticated email address. This
      # method uses the `browserid.user_model` and `browserid.email_field`
      # config settings, which default to `User` and `email`.
      #
      # Returns the current authenticated user, or nil if no user exists.
      def browserid_current_user
        if browserid_email.nil?
          nil
        elsif @browserid_current_user
          @browserid_current_user
        else
          config = browserid_config
          user_model = config.user_model.constantize
          find_method = "find_by_#{config.email_field}".intern

          @browserid_current_user = user_model.send find_method, browserid_email
        end
      end

      # Public: Determines whether the current client is authenticated as a
      # registered User.
      #
      # Returns true if the client is authenticated and registered.
      def browserid_authenticated?
        !browserid_current_user.nil?
      end



      ##### AUTHENTICATION METHODS #####

      # Public: Sets the given email address as the currently-authenticated user.
      # The address is saved in the client's session.
      #
      # email - The String email address to consider authenticated.
      def login_browserid(email)
        session[browserid_config.session_variable] = email
      end

      # Public: Clears the saved email address for the currently-authenticated
      # user. It is important to note that this does not remove the BrowserID
      # assertion in the client's browser.
      def logout_browserid
        session[browserid_config.session_variable] = nil
      end

      # Public: Uses the configured verifier to check that a provided assertion
      # is correct for the site audience.
      #
      # Returns the verified email, identity issuer, and audience on success.
      # Raises an error with a failure message if the client was not
      # successfully authenticated.
      #
      # Examples
      #
      #   verify_browserid(assertion)
      #   # => "user@example.com", "persona.mozilla.com", "https://app.example.com:443"
      #
      def verify_browserid(assertion)
        audience = browserid_config.audience
        audience ||= "%s%s:%d" % [request.protocol, request.host, request.port]
        browserid_config.verifier.verify(assertion, audience)
      end

      # Public: Handles a POST-ed BrowserID assertion, responding appropriately
      # to the request. If successful, this logs-in the authenticated email and
      # returns an OK status. If unsuccessful, it returns FORBIDDEN and an
      # error message in the response body.
      #
      # Returns nothing.
      #
      # Examples
      #
      #   # POST /login
      #   def create
      #     respond_to_browserid
      #   end
      #
      def respond_to_browserid
        if params[:assertion].blank?
          head :bad_request
        else
          email, issuer, audience = verify_browserid params[:assertion]
          logger.info "Verified BrowserID assertion for #{email} issued by #{issuer} on #{audience}"
          login_browserid email
          head :ok
        end
      rescue StandardError => e
        # TODO: distinguish between process failures and invalid assertions
        logger.warn "Failed to verify BrowserID assertion: #{e.message}"
        render status: :forbidden, text: e.message
      end
    end
  end
end
