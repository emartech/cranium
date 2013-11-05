class Cranium::DefinitionRegistry

  def initialize(definition_class)
    @definition_class = definition_class
    @definitions = {}
  end



  def [](name)
    @definitions[name]
  end



  def register_definition(name, &block)
    definition = @definition_class.new name
    definition.instance_eval &block
    @definitions[name] = definition
  end
end
