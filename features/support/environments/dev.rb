Cranium.configure do |config|
  config.greenplum_connection_string = "postgres://cranium:cranium@192.168.56.42:5432/cranium"
  config.gpfdist_url = "gpfdhost:8123"
  config.gpfdist_home_directory = ENV["GPFDIST_HOME"]
  config.upload_directory = "cranium_build"
end
