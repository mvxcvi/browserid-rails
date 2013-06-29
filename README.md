Modified fork of [https://github.com/mvxcvi/browserid-rails](https://github.com/mvxcvi/browserid-rails) to be compatible with Devise so these two gems cound be used together. This is not browserid integration for devise, for that check out [devise-browserid](https://github.com/ringe/devise-browserid).

# BrowserID::Rails

This gem provides a lightweight single-sign-on authentication structure to a
Rails application based on
[Mozilla's Persona service](https://login.persona.org/about). Persona
authenticates clients uniquely by their email address using the BrowserID
protocol, without exposing clients' browsing behaviors to the identity provider.
This also frees the application from needing to securely handle and store user
credentials.

## Overview

BrowserID affords a very easy SSO experience for clients. A simplified version
of the authentication flow goes like this:

1. The user clicks a login link on the site.
2. A pop-up window directs the user to authenticate with their identity
   provider. This will either be their email provider or Mozilla's fall-back
   Persona service.
3. If the authentication is successful, the browser acquires a certificate
   proving that the client owns the email address in question. This only needs
   to be done once for an email address across any number of domains; after
   that the user can just click a button to use that address to authenticate.
4. The browser then uses the certificate to sign an authentication assertion
   for the site (given by the `audience` parameter).
5. The browser POSTs the signed assertion to a session creation URL for
   verification.  If the assertion is valid, the authenticated email is stored
   in the client's session and the page is reloaded.

At this point, the `browserid_email` method will return the stored email
address, and `browserid_current_user` will look up the authenticated user model.
See below for more detailed documentation of the available controller and helper
methods.

Logging out is also straightforward:

1. The (authenticated) user clicks a logout link on the site.
2. The browser clears its stored assertion for the site and POSTs a
   request to the server to clear its login state.
3. The server removes the authenticated email stored in the client's session
   and reloads the page.

## Installation

Add this line to your application's Gemfile:

    gem 'browserid-auth-rails'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install browserid-auth-rails

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
* `email_field` - The attribute of the user model which contains the user's
  email. The default is `:email`.
* `session_variable` - The location the authenticated email is stored in the
  client's session. The default is `:browserid_email`.
* `verifier` - The type of verifier to use to authenticate client BrowserID
  assertions. The default is `:persona`, which sends the request to Mozilla's
  Persona verification service. In the future, `:local` will enable local
  verification code. Alternately, this configuration option may be set to any
  object which responds to `#verify(assertion, audience)` with the verified
  email and identity provider on success and raises an error on failure.
* `audience` - The BrowserID audience to authenticate to. This should consist
  of a URI string containing the scheme (protocol), authority, and port of the
  service (e.g., `"https://app.example.com:443"`). By default, the audience is
  not hardcoded and the properties of the request object are used to construct
  it dynamically. This gives greater flexibility while developing, but is also
  a minor security risk. In production, this should be configured to a fixed
  value.

Additionally, there are two sub-structures `login` and `logout` for configuring
the associated paths and default link text. They have the following properties:

* `text` - The default text to give login and logout links.
* `path` - The target to give links and the path to `POST` authentication
           requests to. Defaults to `"/login"` and `"/logout"` respectively.

So, if you wanted the application to use 'signin' and 'signout' instead, you
could do the following:

    config.browserid.login.text  = "Sign-in"
    config.browserid.login.path  = '/signin'
    config.browserid.logout.text = "Sign-out"
    config.browserid.logout.path = '/signout'

### Controller Integration

The `BrowserID::Rails::Base` module makes several controller methods available
to interact with the authentication system. To access information, use one of:

* `browserid_email` - Returns the BrowserID-authenticated email address, if any.
* `browserid_current_user` - Retrieves the model for the currently authenticated
  user, if there is an authenticated email and a matching user exists.
* `browserid_authenticated?` - Returns true if there is a current user.

These methods are also available in views as helpers.

To control authentication, the app should have a `SessionsController` which
connects the in-browser authentication code to the server. The gem provides
these methods:

* `login_browserid` - Sets the given string as the authenticated email.
* `logout_browserid` - Clears the current authenticated email.
* `verify_browserid` - Uses the configured verifier to confirm a BrowserID
  assertion is correct for the service audience.
* `respond_to_browserid` - Wraps `verify_browserid` in logging and error
  handling logic and generates controller responses to a `POST` assertion.

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
`logout_link` helpers. These accept an optional link text as a parameter:

    <%= logout_link %>

    <%= login_link "Login with Persona" %>

The coffeescript asset adds on-click handlers to the links which trigger the
Persona code to request new assertions or destroy existing ones.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Future Work

* In the future, it would be nice to have a generator to create routes and
  session controller skeletons. This would simplify setup and integration with
  new apps quite a bit.
* Another to-do item is to incorporate the Persona branding assets and add more
  helpers for generating login buttons.
