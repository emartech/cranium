
class Cranium::TransformDefinition

  attr_reader :source_name
  attr_reader :target_name

  def initialize names
    @source_name = names.keys[0]
    @target_name = names.values[0]
  end

end