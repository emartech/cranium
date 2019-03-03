Gem::Specification.new do |spec|
  spec.name = 'cranium'
  spec.version = '0.4.3'
  spec.authors = ['Emarsys Technologies']
  spec.email = ['smart-insight-dev@emarsys.com']
  spec.description = %q{Provides Extract, Transform and Load functionality for loading data from CSV files to a Greenplum database.}
  spec.summary = %q{Pure Ruby ETL framework}
  spec.homepage = 'https://github.com/emartech/cranium'
  spec.license = 'MIT'

  spec.files = `git ls-files`.split($/)
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'pg', '~> 0'
  spec.add_runtime_dependency 'progressbar', '~> 0'
  spec.add_runtime_dependency 'sequel', '>= 4', '< 6'
  spec.add_runtime_dependency 'slop', '~> 3'

  spec.add_development_dependency 'bundler', '~> 1'
  spec.add_development_dependency 'rake', '~> 10'
  spec.add_development_dependency 'rspec', '~> 3'
  spec.add_development_dependency 'ruby-prof', '~> 0'
  spec.add_development_dependency 'cucumber', '~> 1'
  spec.add_development_dependency 'dotenv', '~> 2.5'
end
