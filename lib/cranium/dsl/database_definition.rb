class Cranium::DSL::DatabaseDefinition

  class << self
    include Cranium::AttributeDSL
  end

  attr_reader :name

  define_attribute :connect_to



  def initialize(name)
    @name = name
  end



  def ==(other)
    name == other.name and connect_to == other.connect_to
  end

end
