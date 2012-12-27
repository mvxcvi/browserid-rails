module BrowserID
  module Rails
    # Public: Base module for inclusion into a controller. This module includes
    # methods for dealing with Persona user authentication. There must be a
    # `find_user_by_email` method which looks up a user by email address.
    module Base
      # Internal: Modifies the controller this module is included in to provide
      # authentication-related helper methods
      #
      # base - The Class the module is being included in.
      def self.included(base)
        base.send :helper_method, :persona_email, :current_user, :authenticated?
      end

      private

      # Public: Sets the given email address as the currently-authenticated user.
      # The address is saved in the client's session.
      #
      # email - The String email address to consider authenticated.
      def login_persona(email)
        session[:persona_email] = email
      end

      # Public: Clears the saved email address for the currently-authenticated
      # user. It is important to note that this does not remove the Persona
      # assertion in the client's browser.
      def logout_persona
        session[:persona_email] = nil
      end

      # Public: Gets the email address of the currently-authenticated user.
      #
      # Returns the authenticated email address String.
      def persona_email
        session[:persona_email]
      end

      # Public: Retrieves the user for the currently-authenticated email address.
      # This expects a method named `find_user_by_email` which returns the user
      # for a given email address.
      #
      # Returns the current authenticated user, or nil if no user exists.
      def current_user
        @current_user ||= find_user_by_email(persona_email) if persona_email
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
