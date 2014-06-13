case ENV["CRANIUM_ENVIRONMENT"]
  when "dev"
    Cranium.configure do |config|
      config.greenplum_connection_string = "postgres://cranium:cranium@192.168.56.43:5432/cranium"
      config.gpfdist_url = "192.168.56.43:8123"
      config.gpfdist_home_directory = "tmp/custdata"
      config.upload_directory = "cranium_build"
    end

  when "build"
    Cranium.configure do |config|
      config.greenplum_connection_string = "postgres://cranium@localhost/cranium"
      config.gpfdist_home_directory = "/home/gpadmin/smart-insight-data"
      config.gpfdist_url = "gpfdhost:8123"
      config.upload_directory = "cranium_build"
    end

  else
    raise "Unknown Cranium environment '#{ENV["CRANIUM_ENVIRONMENT"]}'.\nPlease set $CRANIUM_ENVIRONMENT to 'dev' or 'build' to continue."
end

raise "Configuration missing" if Cranium.configuration.gpfdist_home_directory.nil? or Cranium.configuration.upload_directory.nil?
