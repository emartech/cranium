class Cranium::Configuration

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



  def working_directory
    File.join upload_path, ".cranium"
  end

end
