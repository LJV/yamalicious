# Yamalicious

The purpose of this gem is to load configuration information from YAML files and environment variables into a globally available
nested hash (actually a Hashie::Mash rather than a hash).

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
    gem 'yamalicious'
    
### Initializer

In an initializer,

    # config/initializers/_load_config.rb
    APP_CONFIG = Yamalicious.load_config
    
This will load YAML from `yamalicious.yml`, `yamalicious.local.yml`, and from an environment variable named `yamalicious`.

### Configuration

If you wish to adjust which files are loaded and what environment variable is used, just pass a hash containing `:file_prefix` to `load_config` like this:

    # config/initializers/_load_config.rb
    APP_CONFIG = Yamalicious.load_config(:file_prefix => "settings")
    
This will load YAML from `settings.yml`, `settings.local.yml`, and from an environment variable named `settings`

### Avoiding global constant

If you don't like using a global constant like `APP_CONFIG`, you can use Rails' built in configuration object like this:

    # config/initializers/_load_config.rb
    Rails.configuration.yamalicious = Yamalicious.load_config
  
### YAML files

The YAML should contain a section for each environment as well as a section named default, like this:

    # yamalicious.yml
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

1. `yamalicious` environment variable
2. `yamalicious.local.yml`
3. `yamalicious.yml`

### Result
  
The result of the `load_config` method is a Hashie::Mash, which you can treat as a hash that is accessible with loose object notation like this:

    APP_CONFIG.section.nested_section.value
   
You can read more about that [here] [1]

### Loading more than one set of files:

    # config/initializers/_load_config.rb
    EMAIL_CONFIG = Yamalicious.load_config(:file_prefix => "email_settings")
    OTHER_CONFIG = Yamalicious.load_config(:file_prefix => "other_settings")
    
    
  [1]: https://github.com/intridea/hashie/