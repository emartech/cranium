require 'yaml'

class Cranium::Extract::Storage

  STORAGE_FILE_NAME = "extracts"



  def initialize(extract_name)
    @extract_name = extract_name
  end



  def last_value_of(field)
    stored_values[@extract_name][:last_values][field]
  end



  def save_last_value_of(field, value)
    stored_values[@extract_name][:last_values][field] = value
    save_stored_values
  end



  private

  def storage_file
    File.join Cranium.configuration.working_directory, STORAGE_FILE_NAME
  end



  def stored_values
    return @stored_values unless @stored_values.nil?
    @stored_values = (File.exists? storage_file) ? YAML.load(File.read storage_file) : { @extract_name => { last_values: {} } }
  end



  def save_stored_values
    File.write storage_file, YAML.dump(stored_values)
  end

end
