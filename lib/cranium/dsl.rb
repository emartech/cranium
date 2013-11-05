module Cranium::DSL

  autoload :ImportDefinition, 'cranium/dsl/import_definition'
  autoload :SourceDefinition, 'cranium/dsl/source_definition'
  autoload :TransformDefinition, 'cranium/dsl/transform_definition'


  def source(name, &block)
    Cranium.application.register_source name, &block
  end



  def import(name, &block)
    import_definition = ImportDefinition.new(name)
    import_definition.instance_eval &block
    Cranium::DataImporter.new.import(import_definition)
  end



  def transform(names, &block)
    transform_definition = Cranium::DSL::TransformDefinition.new(names)
    source = Cranium.application.sources[transform_definition.source_name]
    target = Cranium.application.sources[transform_definition.target_name]

    Cranium::DataTransformer.new(source, target).transform(&block)
  end



  def deduplicate(source, options)
    transform source => options[:into] do
      deduplicate_by *options[:by]
    end
  end



  def archive(*sources)
    sources.each do |source_name|
      Cranium::Archiver.archive *Cranium.application.sources[source_name].files
    end
  end

end
