require 'fileutils'

class Cranium::TestFramework::UploadDirectory

  def initialize(working_directory)
    @working_directory = working_directory
  end



  def file_exists?(file_name)
    File.exists? File.join(@working_directory, file_name)
  end



  def read_file(file_name)
    File.read File.join(@working_directory, file_name)
  end



  def save_file(file_name, content)
    File.open(File.join(@working_directory, file_name), "w:UTF-8") { |file| file.write content }
  end



  def remove_directory(path)
    FileUtils.rm_rf path
  end

end
