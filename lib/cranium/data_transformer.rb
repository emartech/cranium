require 'csv'
require 'cranium/extensions/file'

class Cranium::DataTransformer

  def initialize(transform_definition)
    @transform_definition = transform_definition
    @index = Cranium::Transformation::Index.new
    @source = Cranium.application.sources[@transform_definition.source_name]
    @target = Cranium.application.sources[@transform_definition.target_name]
    @record = Cranium::TransformationRecord.new @source.fields.keys, @target.fields.keys
  end



  def lookup(field_name, settings)
    @index.lookup field_name, settings
  end



  def transform(&block)
    raise StandardError, "Source definition '#{@target.name}' cannot overrride the file name because it is a transformation target" if @target.file_name_overriden?

    input_files = Dir[File.join upload_directory, @source.file]
    CSV.open "#{upload_directory}/#{@target.file}", "w:#{@target.encoding}", csv_write_options_for(@target) do |target_file|
      input_files.each { |input_file| transform_input_file input_file, target_file, block }
    end
  end



  private

  def transform_input_file(input_file, target_file, transformation_block)
    Cranium::ProgressOutput.show_progress File.basename(input_file), File.line_count(input_file) do |progress_bar|
      line_number = 0
      CSV.foreach input_file, csv_read_options_for(@source) do |row|
        next if 1 == (line_number += 1)

        @record.input_data = row
        self.instance_exec @record, &transformation_block

        target_file << @record.output_data

        progress_bar.inc
      end
    end
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

end
