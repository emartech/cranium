class Cranium::Source

  class << self
    include Cranium::AttributeDSL
  end

  attr_reader :name
  attr_reader :fields

  define_attribute :file
  define_attribute :delimiter
  define_attribute :escape
  define_attribute :quote
  define_attribute :encoding



  def initialize(name)
    @name = name
    @file = "#{name}.csv"
    @fields = {}
    @delimiter = ","
    @escape = '"'
    @quote = '"'
    @encoding = "UTF-8"
  end



  def field(name, type)
    @fields[name] = type
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

end
