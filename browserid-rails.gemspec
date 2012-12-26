# -*- encoding: utf-8 -*-
require File.expand_path('../lib/browserid-rails/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Greg Look"]
  gem.email         = ["greg@greg-look.net"]
  gem.description   = %q{Rails authentication framework using Mozilla Persona/BrowserID}
  gem.summary       = %q{Rails authentication framework using Mozilla Persona/BrowserID}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "browserid-rails"
  gem.require_paths = ["lib"]
  gem.version       = BrowserID::Rails::VERSION
end
