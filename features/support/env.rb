require 'sequel_greenplum'
require 'yaml'
require 'fileutils'
require_relative "../../lib/cranium"
require_relative "environments"

directory = File.join(Cranium.configuration.gpfdist_home_directory, Cranium.configuration.upload_directory)

Before do
  FileUtils.rm_rf directory
  FileUtils.mkdir_p directory
end

After do
  Cranium::TestFramework::DatabaseTable.cleanup
end

greenplum_connection = Sequel.connect Cranium.configuration.greenplum_connection_string
World do
  Cranium::TestFramework::World.new directory, greenplum_connection
end
