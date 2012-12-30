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
application. The following sections cover configuration, controller
integration, and view helpers.

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

Controllers should use the `verify_browserid(assertion)` method, which will use
the configured verifier to authenticate the client's email address. This method
also sets the currently authenticated email in the client's session with the
`login_browserid(email)` method. On logout, the controller should call
`logout_browserid` to clear the email from the client's session.

TODO: further document controller integration
TODO: write generator to create routes and session controller?

### View Helpers

TODO: document view helpers
TODO: include Persona branding assets?

* `login_link`
* `logout_link`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
