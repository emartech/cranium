class Cranium::Configuration

  attr_accessor :greenplum_connection_string
  attr_accessor :mysql_connection_string
  attr_accessor :upload_directory
  attr_accessor :gpfdist_home_directory
  attr_accessor :gpfdist_url
  attr_accessor :loggers



  def initialize
    @loggers = []
  end

end
