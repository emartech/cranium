class Cranium::DataImporter

  def import(import_definition)
    Cranium::Database.connection.transaction do
      importer_for_definition(import_definition).import
      Cranium.application.apply_hook(:after_import)
    end
  end



  private

  def importer_for_definition(import_definition)
    if import_definition.merge_fields.empty?
      Cranium::ImportStrategy::Delta.new(import_definition)
    else
      Cranium::ImportStrategy::Merge.new(import_definition)
    end
  end

end
