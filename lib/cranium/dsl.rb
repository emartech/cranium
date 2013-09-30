module Cranium
  module DSL

    def source(name, &block)

    end



    def import(name, &block)
      importer = DataImporter.new(name)
      importer.instance_eval &block
      importer.import
    end

  end
end

self.extend Cranium::DSL
