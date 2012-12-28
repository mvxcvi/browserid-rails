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
      # path - String path to link to. If not provided, the `login_path` helper
      #        will be used if it exists. Otherwise, the link will be to '#'.
      def login_link(text="Login", path=nil)
        target = path || respond_to?(:login_path) && login_path || '#'
        link_to text, target, class: :browserid_login
      end

      # Public: Renders a logout link which will clear the current BrowserID
      # authentication status.
      #
      # text - String to use as link text (default: 'Logout').
      # path - String path to link to. If not provided, the `logout_path` helper
      #        will be used if it exists. Otherwise, the link will be to '#'.
      def logout_link(text="Logout", path=nil)
        target = path || respond_to?(:logout_path) && logout_path || '#'
        link_to text, target, class: :browserid_logout
      end
    end
  end
end
