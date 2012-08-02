# FlexibleConfigLoader

The purpose of this gem is to load configuration information from YAML files and environment variables into a globally available
nested hash.

## Goals:

1. Store configuration info in YAML, since it's easy to read and change
2. Allow common settings to be shared among all environments
3. Allow each environment to override the common settings.
4. Allow the YAML to be loaded from two separate files (public and private), so that 
   the developer can store some settings in source control and others outside of source control
5. Allow environment variables to be used instead of YAML files (for Heroku, for example).

## Usage:

Install the gem and setup an intializer.

### Gem

In your gemfile,

    # Gemfile
    gem 'flexible_config_loader'
    
### Initializer

In an initializer,

    # config/initializers/_load_config.rb
    APP_CONFIG = FlexibleConfigLoader.load_config(:file_prefix => "flexible_settings")
    
### Explanation

This will load YAML from `flexible_settings.yml`, `flexible_settings.local.yml`, and from an environment variable named `flexible_settings`.

You can adjust the `:file_prefix` option if you wish to use different filenames (and environment variable name).

### YAML files

The YAML should contain a section for each environment as well as a section named default, like this:

    # flexible_settings.yml
    default:
      api_key: ASDGLKASDG
    
    development:
      api_key: HJASDOSHS 
    
    production:
      api_key: ALSJHDGYD

The YAML is loaded into a nested hash using `YAML.load`

The environment-specific section of the YAML is deep merged into the default section.

### Environment variables

The environment variables should be strict base64 encoded YAML, in the same format as the YAML files, with a default section and a section for each relevant environment.

### Deep merging

The YAML from the two files and the environment variable are deep merged together in the following order of precedence:

1. `flexible_settings` environment variable
2. `flexible_settings.local.yml`
3. `flexible_settings.yml`

### Result
  
The result of the `load_config` method is a Hashie::Mash, which you can treat as a hash that is accessible with loose object notation like this:

    APP_CONFIG.section.nested_section.value
   
You can read more about that [here] [1]

### Loading more than one set of files:

    # config/initializers/_load_config.rb
    EMAIL_CONFIG = FlexibleConfigLoader.load_config(:file_prefix => "email_settings")
    OTHER_CONFIG = FlexibleConfigLoader.load_config(:file_prefix => "other_settings")
    
    
  [1]: https://github.com/intridea/hashie/