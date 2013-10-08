require 'csv'
require 'progressbar'

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

    CSV.open "#{upload_directory}/#{@target.file}", "w:#{@target.encoding}", csv_write_options_for(@target) do |target_file|
      transform_input_file target_file, block
    end
  end



  private

  def transform_input_file(target_file, transformation_block)
    show_progress File.basename(@source.file), file_line_count("#{upload_directory}/#{@source.file}") do |progress_bar|
      header = true
      CSV.foreach "#{upload_directory}/#{@source.file}", csv_read_options_for(@source) do |row|
        if header
          header = false
          next
        end

        @record.input_data = row
        self.instance_exec @record, &transformation_block

        progress_bar.inc if progress_bar
        target_file << @record.output_data
      end
    end
  end



  def show_progress(title, total)
    progress_bar = ProgressBar.new(title, total, STDOUT) if STDOUT.tty?

    yield progress_bar

    progress_bar.finish if progress_bar
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
