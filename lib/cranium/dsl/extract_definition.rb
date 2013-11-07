class Cranium::DSL::ExtractDefinition

  class << self
    include Cranium::AttributeDSL
  end

  attr_reader :name
  attr_reader :storage

  define_attribute :from
  define_attribute :query
  define_attribute :incrementally_by



  def initialize(name)
    @name = name
    @storage = Cranium::Extract::Storage.new name
  end



  def last_extracted_value_of(field, default = nil)
    stored_value = @storage.last_value_of field
    stored_value.nil? ? default : stored_value
  end

end
