class Cranium::ImportDefinition

  class << self
    include Cranium::AttributeDSL
  end


  attr_reader :name
  attr_reader :field_associations
  attr_reader :merge_fields
  define_attribute :to



  def initialize(name)
    @name = name
    @field_associations = {}
    @merge_fields = {}
  end



  def put(field_associations)
    @field_associations.merge! field_associations
  end

  def merge_on(merge_fields)
    @merge_fields.merge! merge_fields
  end
end
