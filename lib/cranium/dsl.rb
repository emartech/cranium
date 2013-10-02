module Cranium
  module DSL

    def source(name, &block)
      Cranium.application.register_source name, &block
    end



    def import(name, &block)
      import_definition = Cranium::ImportDefinition.new(name)
      import_definition.instance_eval &block
      Cranium::DataImporter.new.import(import_definition)
    end



    def transform(names, &block)
      transform_definition = Cranium::TransformDefinition.new(names)
      Cranium::DataTransformer.new.transform(transform_definition, &block)
    end

  end
end

self.extend Cranium::DSL
