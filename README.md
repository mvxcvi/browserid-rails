# BrowserID::Rails

This gem provides a simple authentication structure to a Rails application
based on Mozilla's BrowserID protocol and Persona service. Users are uniquely
authenticated by email address using public-key cryptography. The advantage of
this is that the rails application does not need to worry about storing or
securing user passwords.

## Installation

Add this line to your application's Gemfile:

    gem 'browserid-rails'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install browserid-rails

## Usage

To use this gem once it is installed, it must be integrated into your Rails
application. The following sections cover the gem configuration, controller
integration, and view integration.

### Configuration

There are several configuration options available. There are a number of default
assumptions about the application, which may be overridden as needed.
Configuration settings are properties of `config.browserid`.

* `user_model` - The name of the ActiveModel class for application users.
  The default is `"User"`.
* `email_field` - The name of the attribute on the user model which contains
  the user's email. The default is `"email"`.
* `session_variable` - The location the authenticated email is stored in the
  client's session. The default is `:browserid_email`.
* `verifier` - The type of verifier to use to authenticate client BrowserID
  assertions. The default is `:persona`, which sends the request to Mozilla's
  Persona verification service. In the future, `:local` will enable local
  verification code. Alternately, this configuration option may be set to any
  class which responds to `#verify(assertion)` with the verified email and
  identity provider on success and raises an error on failure.
* `audience` - The BrowserID audience to authenticate to. This should consist
  of a URI string containing the scheme (protocol), authority, and port of the
  service (e.g., `"https://app.example.com:443"`). By default, the audience is
  not hardcoded and the properties of the request object are used to construct
  it dynamically. This gives greater flexibility while developing, but is also
  a minor security risk. In production, this should be configured to a fixed
  value.

### Controller Integration

The `BrowserID::Rails::Base` module makes several controller methods available
to interact with the authentication system. To access information, use one of:

* `browserid_email` - Returns the BrowserID-authenticated email address, if any.
* `current_user` - Retrieves the model for the currently authenticated user, if
  there is an authenticated email and a matching user exists.
* `authenticated?` - Returns true if there is a current user.

These methods are also available in views as helpers.

To control authentication, the app should have a `SessionsController` which
connects the in-browser authentication code to the server. The gem provides
these methods:

* `login_browserid` - Sets the given email address as the authenticated user.
* `logout_browserid` - Clears the current authenticated email.
* `verify_browserid` - Uses the configured verifier to confirm a BrowserID
  assertion is correct for the audience.
* `respond_to_browserid` - Wraps `verify_browserid` in logging and error
  handling logic and generates controller responses to a `POST`ed assertion.

Implementing the required methods for `SessionsController` is straightforward:

    # POST /login
    def create
      respond_to_browserid
    end

    # POST /logout
    def destroy
      logout_browserid
      head :ok
    end

TODO: write generator to create routes and session controller

### Layout Integration

The BrowserID javascript library needs to be loaded on your application pages.
There are two steps to accomplish this:

First, the coffeescript asset file needs to be loaded. In the
`app/assets/javascripts/application.js` manifest, add the following line:

    //= require browserid

Second, the scripts need to be setup in your pages' `<head>` section. The
`setup_browserid` helper method takes care of this for you and gives a couple
of ways to control its behavior:

    <!-- Perform basic BrowserID setup in the head section -->
    <%= setup_browserid %>

    <!-- Setup BrowserID with alert debugging -->
    <%= setup_browserid debug: true %>

    <!-- Setup BrowserID with a custom handler -->
    <%= setup_browserid do %>
      browserid.onLogin = function (data, status, xhr) {
        // ...
      }
    <% end %>

Once that's accomplished, the app is ready to use BrowserID for authentication.
To add login and logout links to the site, use the `login_link` and
`logout_link` helpers. These accept optional link text as a parameter and will
use `login_path` and `logout_path` URL helpers if available.

TODO: include Persona branding assets

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
