require 'fileutils'
require_relative "../../lib/cranium"

FileUtils.mkdir_p("log") unless Dir.exists?("log")

Cranium.configure do |config|
  config.greenplum_connection_string = "postgres://cranium:cranium@192.168.56.43:5432/cranium"
  config.gpfdist_url = "192.168.56.43:8123"
  config.gpfdist_home_directory = "tmp/custdata"
  config.upload_directory = "cranium_build"
end


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
