class Cranium::DSL::ExtractDefinition

  class << self
    include Cranium::AttributeDSL
  end

  attr_reader :name

  define_attribute :from
  define_attribute :query



  def initialize(name)
    @name = name
  end

end
