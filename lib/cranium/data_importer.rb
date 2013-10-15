class Cranium::DataImporter

  include Cranium::Logging



  def import(import_definition)
    number_of_items_imported = 0
    Cranium::Database.connection.transaction do
      number_of_items_imported = importer_for_definition(import_definition).import
      Cranium.application.apply_hook(:after_import)
    end

    record_metric import_definition.name, number_of_items_imported.to_s
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
