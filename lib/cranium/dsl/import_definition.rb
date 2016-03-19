class Cranium::DSL::ImportDefinition

  class << self
    include Cranium::AttributeDSL
  end


  attr_reader :name
  attr_reader :field_associations
  attr_reader :merge_fields

  define_attribute :into
  define_boolean_attribute :truncate_insert
  define_array_attribute :delete_insert_on


  def initialize(name)
    @name = name
    @field_associations = {}
    @merge_fields = {}
  end



  def put(fields)
    @field_associations.merge! fields_hash(fields)
  end



  def merge_on(merge_fields)
    @merge_fields = fields_hash(merge_fields)
  end



  private

  def fields_hash(fields)
    case fields
      when Hash
        return fields
      when Symbol
        return { fields => fields }
      else
        raise ArgumentError, "Unsupported argument for Import::#{caller[0][/`.*'/][1..-2]}"
    end
  end

end
