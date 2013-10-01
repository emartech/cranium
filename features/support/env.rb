require 'sequel'
require 'yaml'
require 'fileutils'
require_relative "../../lib/cranium"

environment = YAML.load_file("#{File.dirname(__FILE__)}/environment.yml")["environment"]
require_relative "environments/#{environment}"

raise "Configuration missing" if Cranium.configuration.gpfdist_home_directory.nil? or Cranium.configuration.upload_directory.nil?
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
