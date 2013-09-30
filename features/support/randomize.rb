cucumber_seed = ENV['CUCUMBER_SEED'] ? ENV['CUCUMBER_SEED'].to_i : srand % 0xFFFF
cucumber_dry_run = nil


AfterConfiguration do |cucumber_config|
  original_files = cucumber_config.feature_files
  cucumber_dry_run = cucumber_config.dry_run?

  config_eigenclass = class << cucumber_config;
    self
  end
  config_eigenclass.send :undef_method, :feature_files
  config_eigenclass.send(:define_method, :feature_files) do
    Kernel.srand cucumber_seed
    original_files.sort_by { Kernel.rand original_files.count }
  end
end


at_exit do
  puts("Cucumber randomized with seed #{cucumber_seed.inspect}") unless cucumber_dry_run
end
