require "yamalicious/version"
require 'i18n/core_ext/hash' 
require 'hashie/mash'
 
# Note deep_merge is in ActiveSupport::CoreExtensionsHash and deep_symbolize_keys is in i18n::CoreExtensions::Hash

module Yamalicious
  def self.load_config(options = {})
    file_prefix = options[:file_prefix] || "yamalicious"
    config_path = [Rails.root, 'config'].join('/')
    
    # Load data from four files:
    # 1) public file (include this in source control)
    # 2) private default file (do not include this in source control)
    # 3) public environment-specific file (include this in source control)
    # 4) private environment-specific file (do not include this in source control)
    
    yaml_files = {:public_default => "#{file_prefix}.default.yml",
                  :private_default => "#{file_prefix}.default.private.yml",
                  :public_environment => "#{file_prefix}.#{Rails.env}.yml"
                  :private_environment => "#{file_prefix}.#{Rails.env}.private.yml"}

    settings = {}
    
    yaml_files.each do |k, filename|
      settings[k] = YAML.load_file([config_path, filename].join("/")) || {} rescue {}
    end        
      
    settings[:env_variable] = YAML.load(Base64.strict_decode64(ENV[file_prefix.to_s])) || {} rescue {}

    combined = {}
    
    [:public_default, :private_default, :public_environment, :private_environment, :env_variable].each do |name|
      combined.deep_merge!(settings[name])
    end
   
    combined.deep_symbolize_keys
  end
end