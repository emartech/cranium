class Cranium::Extract::Strategy::Incremental < Cranium::Extract::Strategy::Base

  protected

  def write_dataset_into_file(target_file, dataset, extract_definition)
    incremental_field, max_value = extract_definition.incrementally_by, nil

    dataset.each do |row|
      max_value = row[incremental_field] if max_value.nil? or row[incremental_field] > max_value
      target_file << row.values
    end

    extract_definition.storage.save_last_value_of incremental_field, max_value
  end

end
