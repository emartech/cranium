require 'yaml'
require 'fileutils'

class Cranium::Extract::Storage

  STORAGE_FILE_NAME = "extracts"



  def initialize(extract_name)
    @extract_name = extract_name
  end



  def last_value_of(field)
    return nil unless stored_values.has_key? @extract_name and stored_values[@extract_name].has_key? :last_values
    stored_values[@extract_name][:last_values][field]
  end



  def save_last_value_of(field, value)
    stored_values[@extract_name][:last_values][field] = value
    save_stored_values
  end



  private

  def stored_values
    return @stored_values unless @stored_values.nil?
    @stored_values = (File.exists? storage_file) ? YAML.load(File.read storage_file) : { @extract_name => { last_values: {} } }
  end



  def storage_file
    File.join storage_dir, STORAGE_FILE_NAME
  end



  def storage_dir
    Cranium.configuration.storage_directory
  end



  def save_stored_values
    FileUtils.mkdir_p storage_dir unless Dir.exists? storage_dir
    File.write storage_file, YAML.dump(stored_values)
  end

end
