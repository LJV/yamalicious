# -*- encoding: utf-8 -*-
require File.expand_path('../lib/flexible_config_loader/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Nathan Wenneker"]
  gem.email         = ["nathan@gladtocode.com"]
  gem.description   = %q{Load configuration from YAML files and environment variables}
  gem.summary       = %q{YAML and environment variable configuration loader}
  gem.homepage      = "https://github.com/naw/flexible_config_loader"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "flexible_config_loader"
  gem.require_paths = ["lib"]
  gem.version       = FlexibleConfigLoader::VERSION
  
  gem.add_dependency 'hashie'
  gem.add_dependency 'rails'
end
