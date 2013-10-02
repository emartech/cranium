
require 'csv'

class Cranium::DataTransformer
  def transform transform_definition
    dir = File.join(Cranium.configuration.gpfdist_home_directory, Cranium.configuration.upload_directory)

    source_definition = Cranium.application.sources[transform_definition.source_name]
    target_definition = Cranium.application.sources[transform_definition.target_name]

    record = Cranium::CSVRecord.new

    CSV.open "#{dir}/#{target_definition.file}", "w:#{target_definition.encoding}", col_sep: target_definition.delimiter, quote_char: target_definition.quote do |target|
      CSV.foreach "#{dir}/#{source_definition.file}", encoding: source_definition.encoding, col_sep: source_definition.delimiter, quote_char: source_definition.quote do |row|
        record.data = row
        yield record
        target << record.data
      end
    end

  end
end