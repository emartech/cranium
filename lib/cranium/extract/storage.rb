require 'yaml'
require 'fileutils'

class Cranium::Extract::Storage

  STORAGE_FILE_NAME = "extracts"



  def initialize(extract_name)
    @extract_name = extract_name
  end



  def last_value_of(field)
    stored_values[:last_values][field]
  end



  def save_last_value_of(field, value)
    stored_values[:last_values][field] = value
    save_stored_values
  end



  private

  def stored_values
    return @stored_values[@extract_name] unless @stored_values.nil?
    @stored_values = (File.exists? storage_file) ? YAML.load(File.read storage_file) : {}
    @stored_values[@extract_name] = { last_values: {} } if @stored_values[@extract_name].nil?
    @stored_values[@extract_name]
  end



  def storage_file
    File.join storage_dir, STORAGE_FILE_NAME
  end



  def storage_dir
    Cranium.configuration.storage_directory
  end



  def save_stored_values
    FileUtils.mkdir_p storage_dir unless Dir.exists? storage_dir
    File.write storage_file, YAML.dump(@stored_values)
  end

end
