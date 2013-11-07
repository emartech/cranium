class Cranium::Configuration

  STORAGE_DIRECTORY_NAME = ".cranium"

  attr_writer :storage_directory
  attr_accessor :archive_directory
  attr_accessor :greenplum_connection_string
  attr_accessor :mysql_connection_string
  attr_accessor :upload_directory
  attr_accessor :gpfdist_home_directory
  attr_accessor :gpfdist_url
  attr_accessor :loggers



  def initialize
    @loggers = []
  end



  def upload_path
    File.join gpfdist_home_directory, upload_directory
  end



  def storage_directory
    return @storage_directory unless @storage_directory.nil?
    File.join upload_path, STORAGE_DIRECTORY_NAME
  end

end
