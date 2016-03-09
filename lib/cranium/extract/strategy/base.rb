require 'csv'

class Cranium::Extract::Strategy::Base

  def execute(extract_definition)
    target_file_name = "#{extract_definition.name}.csv"
    target_file_path = File.join Cranium.configuration.upload_path, target_file_name

    raise StandardError, %Q(Extract halted: a file named "#{target_file_name}" already exists) if File.exists? target_file_path

    CSV.open target_file_path, "w:UTF-8" do |target_file|
      dataset = Cranium::Database[extract_definition.from].fetch extract_definition.query

      target_file << (extract_definition.columns || dataset.columns)
      write_dataset_into_file target_file, dataset, extract_definition
    end
  end



  protected

  def write_dataset_into_file(target_file, dataset, extract_definition)
    raise "This template method must be overriden in descendants"
  end

end
