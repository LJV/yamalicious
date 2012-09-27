# Yamalicious

Please note that this is alpha software and breaking changes may be introduced. Use at your own risk, and be very careful when updating to a newer version, as usage may change without notice.

The purpose of this gem is to load configuration information from YAML files and environment variables into a globally available nested hashes

## Goals:

1. Store configuration info in YAML, since it's easy to read and change
2. Allow common settings to be shared among all environments
3. Allow each environment to override the common settings.
4. Allow the YAML to be loaded from both public and private files, so that 
   the developer can store some settings in source control and others outside of source control
5. Allow the YAML to be stored in separate files for each environment for ease of deployment and security
6. Allow environment variables to be used instead of YAML files (for Heroku, for example).

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
    
This will load YAML from `yamalicious.default.yml`, `yamalicious.default.private.yml`, `yamalicious.production.yml`, `yamalicious.production.private.yml` and from an environment variable named `yamalicious`.

### Configuration

If you wish to adjust which files are loaded and what environment variable is used, just pass a hash containing `:file_prefix` to `load_config` like this:

    # config/initializers/_load_config.rb
    APP_CONFIG = Yamalicious.load_config(:file_prefix => "settings")
    
This will load YAML from `settings.default.yml`, `settings.default.private.yml`, `settings.production.yml`, `settings.production.private.yml`, and from an environment variable named `settings`

### Avoiding global constant

If you don't like using a global constant like `APP_CONFIG`, you can use Rails' built in configuration object like this:

    # config/initializers/_load_config.rb
    Rails.configuration.yamalicious = Yamalicious.load_config
  
### YAML files

Values that you want to be inherited by all environments should be placed in `yamalicious.default.yml`

    # yamalicious.yml
    cloud_container_name: 'our files'

Values that should be shared by all environments but need to be kept private out of source control should be placed in `yamalicious.default.private.yml`
    
    # yamalicious.private.yml
    recaptcha_key: ASDGLKASDG
    
Values that are specific to a given environment should be placed in environment specific files such as `yamalicious.production.yml` and `yamalicious.production.private.yml`.  This could be values that only apply to the given environment, or values for which you want to override the default.

    # yamalicious.production.private.yml
    smtp_settings:
      password: HJASDOSHS 
    recaptcha_key: SomethingOtherThanTheDefault

The YAML is loaded from each file into a nested hash using `YAML.load`

### Environment variables

The environment variables should be strict base64 encoded YAML.

### Deep merging

The YAML from the files and the environment variable are deep merged together in the following order.  A higher number indicates a later merge and thus a higher precedence.

1. `yamalicious.default.yml`
2. `yamalicious.default.private.yml`
3. `yamalicious.production.yml`
4. `yamalicious.production.private.yml`
5. `yamalicious` environment variable

### Result
  
The result of the `load_config` method is a Hash


### Loading more than one set of files:

    # config/initializers/_load_config.rb
    EMAIL_CONFIG = Yamalicious.load_config(:file_prefix => "email_settings")
    OTHER_CONFIG = Yamalicious.load_config(:file_prefix => "other_settings")