require 'open3'
require 'fileutils'

class Cranium::TestFramework::World

  DEFINITION_FILE = "import_csv.rb"



  def initialize(greenplum_connection)
    @greenplum_connection = greenplum_connection
  end



  def save_definition(definition)
    save_file DEFINITION_FILE, definition
  end



  def save_file(file_name, content, directory = Dir.pwd)
    FileUtils.mkdir_p directory unless Dir.exists? directory
    File.open(File.join(directory, file_name), "w:UTF-8") { |file| file.write content }
  end



  def execute_definition
    out, err, status = Open3.capture3("bundle exec cranium #{DEFINITION_FILE}")
    puts "output: #{out}"
    puts "error: #{err}"
    puts "exit status: #{status.exitstatus}"
  end



  def database_table(table_name)
    Cranium::TestFramework::DatabaseTable.new table_name, @greenplum_connection
  end

end
