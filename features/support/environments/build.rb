Cranium.configure do |config|
  config.greenplum_connection_string = "postgres://cranium@localhost/cranium"
  config.gpfdist_home_directory = "/home/gpadmin/smart-insight-data"
  config.gpfdist_url = "gpfdhost:8123"
  config.upload_directory = "cranium_build"
end
