require 'open3'

class Cranium::TestFramework::World

  DEFINITION_FILE = "import_csv.rb"



  def save_definition(definition)
    save_file DEFINITION_FILE, definition
  end



  def save_file(file_name, content)
    File.open(file_name, "w:UTF-8") { |file| file.write content }
  end



  def execute_definition
    out, err, status = Open3.capture3("bundle exec cranium #{DEFINITION_FILE}")
    puts "output: #{out}"
    puts "error: #{err}"
    puts "exit status: #{status.exitstatus}"
  end

end
