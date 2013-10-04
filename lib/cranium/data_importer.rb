require 'sequel'

class Cranium::DataImporter

  def import(import_definition)
    if import_definition.merge_fields.empty?
      importer = Cranium::ImportStrategy::Delta.new(import_definition)
    else
      importer = Cranium::ImportStrategy::Merge.new(import_definition)
    end
    importer.import
  end

end
