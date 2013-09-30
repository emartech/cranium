require 'sequel'
require 'tmpdir'
require_relative "../../lib/cranium"

Cranium.configure do |config|
  config.greenplum_connection_string = "postgres://cranium:cranium@192.168.56.42:5432/cranium"
  config.gpfdist_url = "gpfdist://gpfdhost:8123"
  config.gpfdist_home_directory = ENV["GPFDIST_HOME"]
end

greenplum_connection = Sequel.connect "postgres://cranium:cranium@192.168.56.42:5432/cranium"
greenplum_connection.logger = Logger.new('log/query.log')


Around do |_, block|
  Dir.mktmpdir nil, Cranium.configuration.gpfdist_home_directory do |dir|
    Cranium.configure do |config|
      config.upload_directory = "#{dir.sub Cranium.configuration.gpfdist_home_directory, ""}/data"
    end

    Dir.chdir dir
    block.call
    Cranium::TestFramework::DatabaseTable.cleanup
  end
end


World do
  Cranium::TestFramework::World.new greenplum_connection
end
