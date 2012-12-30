# -*- encoding: utf-8 -*-
require File.expand_path('../lib/browserid/rails/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Greg Look"]
  gem.email         = ["greg@greg-look.net"]
  gem.summary       = %q{Rails authentication framework using Mozilla Persona and the BrowserID protocol.}
  #gem.description   = %q{Rails authentication framework using Mozilla Persona/BrowserID}
  gem.homepage      = ""

  #gem.files         = `git ls-files`.split($\)
  gem.files         = Dir["{app,lib,vendor}/**/*"] + ["LICENSE", "README.md"]
  gem.test_files    = gem.files.grep(%r{^spec/})
  gem.name          = "browserid-rails"
  gem.require_paths = ["lib"]
  gem.version       = BrowserID::Rails::VERSION

  gem.add_dependency 'railties', '~> 3.1'
  #gem.add_development_dependency 'rspec', '~> 2.6'
end
