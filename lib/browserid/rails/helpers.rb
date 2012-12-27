module BrowserID
  module Rails
    # Public: Rails view helpers for use with BrowserID code.
    module Helpers
      # Public: Renders a layout partial which initializes the BrowserID
      # system. This should be called in the head of the application layout.
      def setup_browserid
        render 'layouts/browserid'
      end

      # Public: Renders a login link which will request a new authentication
      # assertion from the BrowserID javascript code.
      #
      # text - String to use as link text (default: 'Login').
      def login_link(text="Login")
        link_to text, '#', class: :browserid_login
      end

      # Public: Renders a logout link which will clear the current BrowserID
      # authentication status.
      #
      # text - String to use as link text (default: 'Logout').
      def logout_link(text="Logout")
        link_to text, '#', class: :browserid_logout
      end
    end
  end
end
