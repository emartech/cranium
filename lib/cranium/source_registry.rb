class Cranium::SourceRegistry

  def initialize
    @sources = {}
  end



  def [](name)
    @sources[name]
  end



  def register_source(name, &block)
    source = Cranium::DSL::SourceDefinition.new name
    source.instance_eval &block
    @sources[name] = source
  end

end
