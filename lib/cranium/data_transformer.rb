require 'csv'
require 'cranium/extensions/file'

class Cranium::DataTransformer

  def initialize(source, target)
    @source, @target = source, target
    @index = Cranium::Transformation::Index.new
    @record = Cranium::TransformationRecord.new @source.fields.keys, @target.fields.keys
  end



  def transform(&block)
    raise StandardError, "Source definition '#{@target.name}' cannot overrride the file name because it is a transformation target" if @target.file_name_overriden?

    CSV.open "#{Cranium.configuration.upload_path}/#{@target.file}", "w:#{@target.encoding}", csv_write_options_for(@target) do |target_file|
      @target_file = target_file
      @source.files.each do |input_file|
        transform_input_file File.join(Cranium.configuration.upload_path, input_file), block
      end
    end

    @target.resolve_files
  end



  private

  def transform_input_file(input_file, transformation_block)
    Cranium::ProgressOutput.show_progress File.basename(input_file), File.line_count(input_file) do |progress_bar|
      line_number = 0
      CSV.foreach input_file, csv_read_options_for(@source) do |row|
        next if 1 == (line_number += 1)

        @record.skip false
        @record.input_data = row
        self.instance_exec @record, &transformation_block

        progress_bar.inc
      end
    end
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



  def output(record)
    @target_file << record.output_data
  end



  def unique_on_fields?(*fields)
    not Cranium::Transformation::DuplicationIndex[*fields].duplicate? @record
  end



  def lookup(field_name, settings)
    @index.lookup field_name, settings
  end



  def next_value_in_sequence(name)
    Cranium::Transformation::Sequence.by_name name
  end



  alias_method :sequence, :next_value_in_sequence

end
