module BrowserID
  module Rails
    # Public: Rails view helpers for use with BrowserID code.
    module Helpers
      # Public: Renders a layout partial which initializes the BrowserID
      # system. This should be called in the head of the application layout.
      #
      # options - Hash used to adjust the browserid asset setup (default: {}).
      #           :login_path  - String giving the path to POST assertions to
      #                          for verification.
      #           :logout_path - String giving the path to POST logout
      #                          notifications to.
      #           :debug       - Boolean determining whether the browserid
      #                          javascript will refresh the page or show an
      #                          alert dialog.
      # block   - An optional block which can be used to provide additional
      #           content to be rendered inside the browserid setup script tag.
      #
      # Examples
      #
      #   <!-- Perform basic BrowserID setup in the head section -->
      #   <%= setup_browserid %>
      #
      #   <!-- Setup BrowserID with alert debugging -->
      #   <%= setup_browserid debug: true %>
      #
      #   <!-- Setup BrowserID with a custom handler -->
      #   <%= setup_browserid do %>
      #     browserid.onLogin = function (data, status, xhr) {
      #       // ...
      #     }
      #   <% end %>
      #
      def setup_browserid(options={}, &block)
        content_for :browserid_setup, capture(&block) if block_given?
        render 'layouts/browserid', options: options
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
