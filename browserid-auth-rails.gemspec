# -*- encoding: utf-8 -*-

# Load gem version.
require File.expand_path('../lib/browserid/rails/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "browserid-auth-rails"
  gem.version       = BrowserID::Rails::VERSION
  gem.homepage      = "https://github.com/alexkravets/browserid-auth-rails"

  gem.authors       = ["Greg Look", "Alex Kravets"]
  gem.email         = ["alex@slatestudio.com"]
  gem.summary       = %q{Lightweight Rails authentication framework using the BrowserID protocol.}
  gem.description   = <<-EOF
    This gem provides a lightweight single-sign-on authentication framework to
    a Rails application based on Mozilla's Persona service (see:
    https://login.persona.org/about). Persona identifies users by email address
    and authenticates them using the BrowserID protocol. This lets a client
    prove they own an email address without exposing their browsing behaviors to
    the identity provider. This also frees the application from needing to
    securely handle and store user credentials.
  EOF

  gem.files         = Dir["{app,lib,vendor}/**/*"] + ["LICENSE", "README.md"]
  gem.test_files    = gem.files.grep(%r{^spec/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'railties', '>= 3.2'

  gem.add_development_dependency 'rspec-rails', '>= 2.11'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'tzinfo' # required for active-support

  gem.add_runtime_dependency 'jquery-rails'
end
