Gem::Specification.new do |spec|
  spec.name          = "cranium"
  spec.version       = "0.1.146"
  spec.authors       = ["Emarsys Technologies"]
  spec.email         = ["smart-insight-dev@emarsys.com"]
  spec.description   = %q{Provides Extract, Transform and Load functionality for loading data from CSV files to a Greenplum database.}
  spec.summary       = %q{Pure Ruby ETL framework}
  spec.homepage      = "http://gems.ett.local"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "pg"
  spec.add_runtime_dependency "progressbar"
  spec.add_runtime_dependency "sequel"
  spec.add_runtime_dependency "slop"


  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency "ruby-prof"
  spec.add_development_dependency "cucumber", "~> 1.3.10"
  # spec.add_development_dependency "geminabox_client"
end
