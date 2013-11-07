require 'csv'

class Cranium::Extract::DataExtractor

  def execute(extract_definition)
    CSV.open "#{Cranium.configuration.upload_path}/#{extract_definition.name}.csv", "w:UTF-8" do |target_file|
      dataset = Cranium::Database[extract_definition.from].fetch extract_definition.query

      target_file << dataset.columns
      dataset.each do |row|
        target_file << row.values
      end
    end
  end

end
