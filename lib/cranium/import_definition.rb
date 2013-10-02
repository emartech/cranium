class Cranium::ImportDefinition

  class << self
    include Cranium::AttributeDSL
  end


  attr_reader :name
  attr_reader :field_associations
  define_attribute :to



  def initialize(name)
    @name = name
    @field_associations = {}
    @merge_fields = []
  end



  def put(field_associations)
    @field_associations.merge! field_associations
  end
end
