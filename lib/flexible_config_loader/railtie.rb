module FlexibleConfigLoader
  class Railtie < Rails::Railtie
    before_initialize 'flexible_config_loader.load_config' do
      FlexibleConfigLeader.load_config
    end
  end
end

