require 'open3'

class Cranium::TestFramework::World

  DEFINITION_FILE = "import_csv.rb"



  def initialize(working_directory, greenplum_connection)
    @greenplum_connection = greenplum_connection
    @directory = working_directory
  end



  def upload_directory
    @upload_directory ||= Cranium::TestFramework::UploadDirectory.new @directory
  end



  def save_definition(definition)
    config = <<-config_string
      require 'logger'

      Cranium.configure do |config|
        config.greenplum_connection_string = "#{Cranium.configuration.greenplum_connection_string}"
        config.gpfdist_url = "#{Cranium.configuration.gpfdist_url}"
        config.gpfdist_home_directory = "#{Cranium.configuration.gpfdist_home_directory}"
        config.upload_directory = "#{Cranium.configuration.upload_directory}"
        config.loggers << Logger.new("log/application.log")
      end
    config_string

    upload_directory.save_file DEFINITION_FILE, config + definition
  end



  def execute_definition
    out, err, status = Open3.capture3("bundle exec cranium #{@directory}/#{DEFINITION_FILE}")
    unless out.empty? and err.empty? and status.exitstatus.zero?
      puts "output: #{out}"
      puts "error: #{err}"
      puts "exit status: #{status.exitstatus}"
    end
  end



  def database_table(table_name)
    Cranium::TestFramework::DatabaseTable.new table_name, @greenplum_connection
  end

end
