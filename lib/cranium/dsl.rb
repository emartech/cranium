module Cranium::DSL

  autoload :ImportDefinition, 'cranium/dsl/import_definition'
  autoload :SourceDefinition, 'cranium/dsl/source_definition'



  def source(name, &block)
    Cranium.application.register_source name, &block
  end



  def import(name, &block)
    import_definition = ImportDefinition.new(name)
    import_definition.instance_eval &block
    Cranium::DataImporter.new.import(import_definition)
  end



  def transform(names, &block)
    transform_definition = Cranium::TransformDefinition.new(names)
    Cranium::DataTransformer.new(transform_definition).transform(&block)
  end

end
