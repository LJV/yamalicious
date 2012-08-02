require "flexible_config_loader/version"
require 'i18n/core_ext/hash' 
require 'hashie/mash'
 
# Note deep_merge is in ActiveSupport::CoreExtensionsHash and deep_symbolize_keys is in i18n::CoreExtensions::Hash

module FlexibleConfigLoader
  def self.load_config(options = {})
    file_prefix = options[:file_prefix] || "flexible_settings"
    config_path = [Rails.root, 'config'].join('/')
    
 
    yaml_files = {:public => "#{file_prefix}.yml",
                  :private => "#{file_prefix}.local.yml"}

    settings = {}
    
    yaml_files.each do |k, filename|
      settings[k] = YAML.load_file([config_path, filename].join("/")) || {} rescue {}
    end        
      
    settings[:env] = YAML.load(Base64.strict_decode64(ENV[file_prefix.to_s])) || {} rescue {}

    combined = {}

    [:public, :private, :env].each do |name|
      default_settings = settings[name]["default"] || {}
      environment_settings = settings[name][Rails.env] || {}
      combined.deep_merge!(default_settings.deep_merge(environment_settings))
    end
   
    ::Hashie::Mash.new(combined.deep_symbolize_keys)
  end
end