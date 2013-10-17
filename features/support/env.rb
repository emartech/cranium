require 'fileutils'
require_relative "../../lib/cranium"
require_relative "environments"

Before do
  FileUtils.rm_rf Cranium.configuration.upload_path
  FileUtils.mkdir_p Cranium.configuration.upload_path
end

After do
  Cranium::TestFramework::DatabaseTable.cleanup
  Cranium::TestFramework::DatabaseSequence.cleanup
end

World do
  Cranium::TestFramework::World.new Cranium.configuration.upload_path, Cranium::Database.connection
end
