require 'csv'

class Cranium::Extract::Strategy::Base

  def execute(extract_definition)
    CSV.open "#{Cranium.configuration.upload_path}/#{extract_definition.name}.csv", "w:UTF-8" do |target_file|
      dataset = Cranium::Database[extract_definition.from].fetch extract_definition.query

      target_file << dataset.columns
      write_dataset_into_file target_file, dataset, extract_definition
    end
  end



  protected

  def write_dataset_into_file(target_file, dataset, extract_definition)
    raise "This template method must be overriden in descendants"
  end

end
