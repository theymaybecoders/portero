# -*- encoding: utf-8 -*-
require File.expand_path('../lib/portero/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Robert Rouse"]
  gem.email         = ["robert@theymaybecoders.com"]
  gem.description   = %q{Portero will help you find venues around a location using as many services known}
  gem.summary       = %q{Portero will help you find venues around a location using as many services known}
  gem.homepage      = "http://github.com/theymaybecoders"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "portero"
  gem.require_paths = ["lib"]
  gem.version       = Portero::VERSION

  gem.add_development_dependency "rspec", '~>2.0'
  gem.add_development_dependency "shoulda-matchers", '~>1.2'
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "fakeweb"

  gem.add_dependency "faraday", '~>0.8'
  gem.add_dependency "activesupport", '~> 3'
end
