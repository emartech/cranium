require 'logger'

Cranium.configure do |config|
  config.greenplum_connection_string = "postgres://cranium:cranium@192.168.56.43:5432/cranium"
  config.gpfdist_url = "192.168.56.43:8123"
  config.gpfdist_home_directory = "tmp/custdata"
  config.upload_directory = "cranium_build"
  config.archive_directory = "cranium_archive"
  config.loggers << Logger.new("log/application.log")
end

database :suite do
  connect_to "postgres://cranium:cranium@192.168.56.43:5432/cranium"
end
