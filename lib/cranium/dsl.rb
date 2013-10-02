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

  end
end

self.extend Cranium::DSL
