require "flexible_config_loader/version"
require "flexible_config_loader/railtie" if defined? Rails
require 'i18n/core_ext/hash' 
 
# Note deep_merge is in ActiveSupport::CoreExtensionsHash and deep_symbolize_keys is in i18n::CoreExtensions::Hash,
# which we require explicitly.

module FlexibleConfigLoader

  def self.load_config
    config_path = [Rails.root, 'config', 'yaml_settings'].join('/')

    yaml_files =  {:common_file => config_path + '/common.yml',
                  :common_private_file => config_path + '/private/common.yml',
                  :environment_file => config_path + "/#{Rails.env}.yml",
                  :environment_private_file => config_path + "/private/#{Rails.env}.yml"}

    env_variables = {:common_env => ENV["common_settings"],
                     :environment_env => ENV["#{Rails.env}_settings"]}

    settings = {}

    yaml_files.each do |k, filepath|
      settings[k] = YAML.load_file(filepath) || {} rescue {}
    end    
                             
    # Environment variables are assumed to be base64 strict encoded YAML
    env_variables.each do |k, base64string|
      settings[k] = YAML.load(Base64.strict_decode64(base64string)) || {} rescue {}
    end

    config = {}

    [:common_file, :common_private_file, :common_env, :environment_file, :environment_private_file, :environment_env].each do |name|
      config.deep_merge!(settings[name])
    end

    Rails.configuration.app_config_hash = config.deep_symbolize_keys
  end

end