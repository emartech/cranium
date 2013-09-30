require 'cucumber'
require 'cucumber/rake/task'
require 'rspec/core/rake_task'


desc "Run test suite (all RSpec examples and Cucumber features)"
task :test => [:'test:spec', :'test:features']

desc "Run RSpec code examples (options: RSPEC_SEED=seed)"
task :spec => :'test:spec'

desc "Run Cucumber features (options: CUCUMBER_SEED=seed)"
task :features => :'test:features'


namespace :test do

  desc "Run RSpec code examples (options: RSPEC_SEED=seed)"
  RSpec::Core::RakeTask.new :spec do |task|
    task.verbose = false
    task.rspec_opts = "--order random"
    task.rspec_opts << " --seed #{ENV['RSPEC_SEED']}" if ENV['RSPEC_SEED']
  end


  Cucumber::Rake::Task.new(:features, "Run Cucumber features (options: CUCUMBER_SEED=seed)") do |task|
    task.cucumber_opts = %w[--profile build]
  end

end
