class Cranium::Extract::Strategy::Simple < Cranium::Extract::Strategy::Base

  protected

  def write_dataset_into_file(target_file, dataset, extract_definition)
    dataset.each { |row| target_file << row.values }
  end

end
