class Cranium::DSL::SourceDefinition

  class << self
    include Cranium::AttributeDSL
  end

  attr_reader :name
  attr_reader :files
  attr_reader :fields

  define_attribute :file
  define_attribute :delimiter
  define_attribute :escape
  define_attribute :quote
  define_attribute :encoding



  def initialize(name)
    @name = name
    @file = default_file_name
    @fields = {}
    @delimiter = ","
    @escape = '"'
    @quote = '"'
    @encoding = "UTF-8"
  end



  def resolve_files
    @files = Dir[File.join Cranium.configuration.upload_path, @file].map { |file| File.basename file }.sort
  end



  def field(name, type)
    @fields[name] = type
  end



  def file_name_overriden?
    @file != default_file_name
  end



  def ==(other)
    name == other.name and
      file == other.file and
      delimiter == other.delimiter and
      escape == other.escape and
      quote == other.quote and
      encoding == other.encoding and
      fields == other.fields
  end



  private

  def default_file_name
    "#{@name}.csv"
  end

end
