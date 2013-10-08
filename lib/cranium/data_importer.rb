class Cranium::DataImporter

  def import(import_definition)

    Cranium::Database.connection.transaction do
      if import_definition.merge_fields.empty?
        importer = Cranium::ImportStrategy::Delta.new(import_definition)
      else
        importer = Cranium::ImportStrategy::Merge.new(import_definition)
      end

      importer.import

      Cranium.application.apply_hook(:after_import)
    end

  end

end
