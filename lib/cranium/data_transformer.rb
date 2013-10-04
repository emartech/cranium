require 'csv'
require 'progressbar'

class Cranium::DataTransformer

  def initialize(transform_definition)
    @transform_definition = transform_definition
  end



  def transform
    record = Cranium::TransformationRecord.new source.fields.keys, target.fields.keys

    header = true
    CSV.open "#{upload_directory}/#{target.file}", "w:#{target.encoding}", csv_write_options_for(target) do |target|

      progress_bar = ProgressBar.new(File.basename(source.file), file_line_count("#{upload_directory}/#{source.file}"), STDOUT) if STDOUT.tty?

      CSV.foreach "#{upload_directory}/#{source.file}", csv_read_options_for(source) do |row|
        if header
          header = false
          next
        end

        record.input_data = row
        yield record

        progress_bar.inc if progress_bar
        target << record.output_data
      end

      progress_bar.finish if progress_bar
    end
  end



  private


  def target
    Cranium.application.sources[@transform_definition.target_name]
  end



  def source
    Cranium.application.sources[@transform_definition.source_name]
  end



  def upload_directory
    File.join(Cranium.configuration.gpfdist_home_directory, Cranium.configuration.upload_directory)
  end



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



  def file_line_count(file)
    (`wc -l #{file}`.match /^\s*(?<line_count>\d+).*/)["line_count"].to_i
  end

end
