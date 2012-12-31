# -*- encoding: utf-8 -*-

# Load gem version.
require File.expand_path('../lib/browserid/rails/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "browserid-rails"
  gem.version       = BrowserID::Rails::VERSION
  gem.homepage      = "https://github.com/mvxcvi/browserid-rails"

  gem.authors       = ["Greg Look"]
  gem.email         = ["greg@mvxcvi.com"]
  gem.summary       = %q{Rails authentication framework using Mozilla Persona and the BrowserID protocol.}
  #gem.description   = %q{Rails authentication framework using Mozilla Persona/BrowserID}

  gem.files         = Dir["{app,lib,vendor}/**/*"] + ["LICENSE", "README.md"]
  gem.test_files    = gem.files.grep(%r{^spec/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'railties', '~> 3.2'

  gem.add_development_dependency 'rspec-rails', '~> 2.11'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'tzinfo' # required for active-support

  gem.add_runtime_dependency 'jquery-rails'
end
