require 'open3'

class Cranium::TestFramework::World

  DEFINITION_FILE = "import_csv.rb"



  def initialize(working_directory, greenplum_connection)
    @greenplum_connection = greenplum_connection
    @directory = working_directory
  end



  def file_system
    @file_system ||= Cranium::TestFramework::FileSystem.new @directory
  end



  def save_definition(definition)
    config = <<-config_string
      Cranium.configure do |config|
        config.greenplum_connection_string = "#{Cranium.configuration.greenplum_connection_string}"
        config.gpfdist_url = "#{Cranium.configuration.gpfdist_url}"
        config.gpfdist_home_directory = "#{Cranium.configuration.gpfdist_home_directory}"
        config.upload_directory = "#{Cranium.configuration.upload_directory}"
      end
    config_string

    file_system.save_file DEFINITION_FILE, config + definition
  end



  def execute_definition
    out, err, status = Open3.capture3("bundle exec cranium #{@directory}/#{DEFINITION_FILE}")
  rescue
    puts "output: #{out}"
    puts "error: #{err}"
    puts "exit status: #{status.exitstatus}"
  end



  def database_table(table_name)
    Cranium::TestFramework::DatabaseTable.new table_name, @greenplum_connection
  end

end
