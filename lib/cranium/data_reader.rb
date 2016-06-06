require 'csv'
require 'cranium/extensions/file'

class Cranium::DataReader

  def initialize(source)
    @source = source
    @source_field_names = @source.fields.keys
  end



  def read(&block)
    @source.files.each do |input_file|
      read_input_file File.join(Cranium.configuration.upload_path, input_file), block
    end
  end



  private

  def read_input_file(input_file, read_block)
    Cranium::ProgressOutput.show_progress File.basename(input_file), Cranium::FileUtils.line_count(input_file) do |progress_bar|
      line_number = 0
      CSV.foreach input_file, csv_read_options_for(@source) do |row|
        next if 1 == (line_number += 1)

        record = Hash[@source_field_names.zip row]
        self.instance_exec record, &read_block

        progress_bar.inc
      end
    end
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
