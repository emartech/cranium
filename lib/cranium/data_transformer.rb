require 'csv'

class Cranium::DataTransformer

  def transform(transform_definition)
    dir = File.join(Cranium.configuration.gpfdist_home_directory, Cranium.configuration.upload_directory)

    source_definition = Cranium.application.sources[transform_definition.source_name]
    target_definition = Cranium.application.sources[transform_definition.target_name]

    record = Cranium::TransformationRecord.new source_definition.fields.keys, target_definition.fields.keys

    header = true

    CSV.open "#{dir}/#{target_definition.file}", "w:#{target_definition.encoding}", csv_write_options_for(target_definition) do |target|
      CSV.foreach "#{dir}/#{source_definition.file}", csv_read_options_for(source_definition) do |row|
        if header
          header = false
          next
        end

        record.input_data = row
        yield record
        target << record.output_data
      end
    end
  end



  private

  def csv_write_options_for(source_definition)
    {
      col_sep: source_definition.delimiter,
      quote_char: source_definition.quote,
      write_headers: true,
      headers: source_definition.fields.keys
    }
  end



  def csv_read_options_for(source_definition)
    {
      encoding: source_definition.encoding,
      col_sep: source_definition.delimiter,
      quote_char: source_definition.quote,
      return_headers: false
    }
  end

end
