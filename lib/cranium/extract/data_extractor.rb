require 'csv'

class Cranium::Extract::DataExtractor

  def execute(extract_definition)
    CSV.open "#{Cranium.configuration.upload_path}/#{extract_definition.name}.csv", "w:UTF-8" do |target_file|
      dataset = Cranium::Database[extract_definition.from].fetch extract_definition.query

      incremental_field = extract_definition.incrementally_by
      max_value = nil
      target_file << dataset.columns
      dataset.each do |row|
        unless incremental_field.nil?
          max_value = row[incremental_field] if max_value.nil? or row[incremental_field] > max_value
        end
        target_file << row.values
      end

      unless incremental_field.nil?
        extract_definition.storage.save_last_value_of incremental_field, max_value
      end
    end
  end

end
