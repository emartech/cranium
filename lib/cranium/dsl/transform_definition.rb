class Cranium::DSL::TransformDefinition

  attr_reader :source_name
  attr_reader :target_name



  def initialize(names)
    @source_name = names.keys.first
    @target_name = names.values.first
  end

end
