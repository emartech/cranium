class Cranium::DSL::DatabaseDefinition

  class << self
    include Cranium::AttributeDSL
  end

  attr_reader :name

  define_attribute :connect_to
  define_attribute :retry_count
  define_attribute :retry_delay



  def initialize(name)
    @name = name
    @retry_count = 0
    @retry_delay = 0
  end



  def ==(other)
    name == other.name and connect_to == other.connect_to
  end

end
