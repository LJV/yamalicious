# FlexibleConfigLoader

The purpose of this gem is to load configuration information from YAML files and environment variables into a globally available
nested hash.

## Goals:

1. Store configuration info in YAML, since it's easy to read and change
2. Allow common settings to be shared among all environments
3. Allow each environment to override the common settings.
4. Allow the YAML files to be loaded from both public and private folders so that
   the developer can store some settings in source control and others outside of source control
5. Allow environment variables to be used instead of YAML files (for Heroku, for example).

## Usage:

The base public folder for YAML files is in config/yaml_settings/ 
The base private folder (which should not be included in source control) is config/yaml_settings/private

In each of these folders you can create the following YAML files:

common.yml -- settings shared among all environments
production.yml -- settings for Production environment
development.yml -- settings for Development environment
{environment}.yml -- any other environment you have defined

Environment variables are named as follows:

common_settings -- settings shared among all environments
production_settings -- settings for Production environment
development_settings -- settings for Development environment
{environment}_settings -- settings for any other environment you've defined.

The environment variables should base strict base64 encoded YAML.

The YAML from the files and environment variables is loaded into a nested hash using YAML.load

The settings are deep merged with one another in the following order of precdence:

1) environment specific environment variable (e.g. production_settings)
2) common environment variable (common_settings)
3) environment specific private YAML file (e.g. config/yaml_settings/private/production.yaml)
4) common private YAML file (e.g. config/yaml_settings/private/common.yml)
5) environment specific public YAML file (e.g. config/yaml_settings/production.yaml)
6) common public YAML file (e.g. config/yaml_settings/common.yaml)


If any of the environment variables or YAML files are not present or produce an error while parsing, 
this gem will treat it as if it is an empty hash of data.