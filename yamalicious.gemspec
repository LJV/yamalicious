# -*- encoding: utf-8 -*-
require File.expand_path('../lib/yamalicious/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Nathan Wenneker"]
  gem.email         = ["nathan@gladtocode.com"]
  gem.description   = %q{Load configuration from YAML files and base64 encoded YAML environment variables into a Rails app}
  gem.summary       = %q{YAML configuration loader for Rails apps}
  gem.homepage      = "https://github.com/naw/yamalicious"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "yamalicious"
  gem.require_paths = ["lib"]
  gem.version       = Yamalicious::VERSION
  
  gem.add_dependency 'hashie'
  gem.add_dependency 'rails'
end
